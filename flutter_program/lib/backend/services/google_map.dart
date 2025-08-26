import 'dart:convert';
import 'package:drw/backend/models/hospital_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OpenMarkerStyle { red, gray, star }

class GoogleMapService extends ChangeNotifier {
  // --- state ---
  final Set<Marker> _markers = {};
  static const double walkingSpeedMetersPerSecond = 1.4;

  // 仍保留：全域「營業中」樣式切換（目前你 UI 沒用到也無妨）
  OpenMarkerStyle openMarkerStyle = OpenMarkerStyle.red;

  // 新增：被加星的院所 id
  final Set<int> _starredHospitalIds = {};

  // === 收藏（本機持久化） ===
  String _userId = 'guest';
  String _favKey(String uid) => 'fav_hospitals_$uid';

  bool isStarred(int hospitalId) => _starredHospitalIds.contains(hospitalId);

  Set<int> get starredIds => Set.unmodifiable(_starredHospitalIds);

  void toggleStar(int hospitalId) {
    if (!_starredHospitalIds.add(hospitalId)) {
      _starredHospitalIds.remove(hospitalId);
    }
    _persistFavorites(); // <-- 新增：存到 SharedPreferences
    notifyListeners();
  }

// 用頁面現有的 hospitals 過濾出收藏清單
  List<Hospital> getStarredHospitals(List<Hospital> all) =>
      all.where((h) => _starredHospitalIds.contains(h.id)).toList();

// 初始化或切換帳號時呼叫
  Future<void> initFavorites({required String userId}) async {
    _userId = (userId.isEmpty) ? 'guest' : userId;
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favKey(_userId)) ?? const [];
    _starredHospitalIds
      ..clear()
      ..addAll(ids.map(int.parse));
    notifyListeners();
  }

  Future<void> _persistFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favKey(_userId),
      _starredHospitalIds.map((e) => e.toString()).toList(),
    );
  }

  // --- icon cache：載一次就好 ---
  BitmapDescriptor? _iconGray;
  BitmapDescriptor? _iconRed;
  BitmapDescriptor? _iconStar;

  Future<void> _ensureIcons() async {
    if (_iconGray != null && _iconRed != null && _iconStar != null) return;
    try {
      _iconGray ??= await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5),
        'images/gray_maker.png',
      );
    } catch (_) {}
    try {
      _iconRed ??= await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5),
        'images/red_maker.png',
      );
    } catch (_) {}
    try {
      _iconStar ??= await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5),
        'images/star_marker.png',
      );
    } catch (_) {
      // 若星星圖失敗，之後會自動 fallback 到紅/灰，不中斷流程
    }
    // 保底：至少要有內建紅釘，避免全失敗
    _iconRed ??= BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    _iconGray ??=
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

  String? get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'];

  Future<String?> getBusinessStatus({
    required String placeName,
    required double lat,
    required double lng,
  }) async {
    final key = _apiKey;
    if (key == null) return null;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
      'keyword=${Uri.encodeComponent(placeName)}&location=$lat,$lng&radius=100&key=$key',
    );

    try {
      final res = await http.get(url);
      if (res.statusCode != 200) return null;
      final data = json.decode(res.body);
      final results = (data['results'] as List?) ?? const [];
      if (results.isEmpty) return null;

      final r = results.first;
      final status = r['business_status'];
      if (status == 'CLOSED_PERMANENTLY') return '永久停業';
      if (status == 'CLOSED_TEMPORARILY') return '暫時停業';
      final openNow = r['opening_hours']?['open_now'];
      if (openNow is bool) return openNow ? '營業中' : '已打烊';
      return '狀態未知';
    } catch (_) {
      return null; // API 失敗不影響畫面
    }
  }

  // --- 重畫 markers（穩定版） ---
  Future<void> setMarkers(
    List<Hospital> hospitals,
    Function(Hospital) onMarkerTap,
    LatLng from, {
    required double pinColor, // 你原本的參數，先保留
  }) async {
    await _ensureIcons();

    // 用暫存集合，確定都建好再一次替換，避免「清空後出錯」造成整張圖沒點
    final Set<Marker> next = {};

    await Future.wait(hospitals.map((h) async {
      if (h.latitude == 0.0 || h.longitude == 0.0) return;

      // 距離/時間（可沿用你原本計算）
      h.distance = await calculateDistanceText(
        currentPosition: from,
        hospitalLat: h.latitude,
        hospitalLng: h.longitude,
      );
      h.walkTime = await calculateWalkingTime(
        currentPosition: from,
        hospitalLat: h.latitude,
        hospitalLng: h.longitude,
      );

      // 營業狀態
      h.openStatus = await getBusinessStatus(
        placeName: h.name,
        lat: h.latitude,
        lng: h.longitude,
      );
      final isOpen = h.openStatus == '營業中';

      // 決定 icon：加星 > 營業/未營業
      final starred = _starredHospitalIds.contains(h.id);
      final BitmapDescriptor icon = starred
          ? (_iconStar ?? _iconRed!) // 星星載不到就退回紅色
          : (isOpen ? _iconRed! : _iconGray!);

      next.add(
        Marker(
          markerId: MarkerId(h.id.toString()),
          position: LatLng(h.latitude, h.longitude),
          infoWindow: InfoWindow(title: h.name, snippet: h.address),
          icon: icon,
          onTap: () {
            // 讓地圖點擊先完成，再排進 UI queue 更新 provider，比較不會被地圖手勢影響
            Future.microtask(() => onMarkerTap(h));
          },
        ),
      );
    }));

    // 一次替換，畫面穩定
    _markers
      ..clear()
      ..addAll(next);
    notifyListeners();
  }

  Set<Marker> get markers => _markers;

  Widget buildGoogleMap({
    required LatLng currentPosition,
    required Function(GoogleMapController) onMapCreated,
  }) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: currentPosition, zoom: 14),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) => onMapCreated(controller),
      markers: _markers,
    );
  }

  Future<LatLng?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final p = await Geolocator.getCurrentPosition();
      return LatLng(p.latitude, p.longitude);
    }
    return null;
  }

  Future<double> calculateDistance({
    required LatLng currentPosition,
    required double hospitalLat,
    required double hospitalLng,
  }) async {
    return Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      hospitalLat,
      hospitalLng,
    );
  }

  Future<String> calculateDistanceText({
    required LatLng currentPosition,
    required double hospitalLat,
    required double hospitalLng,
  }) async {
    final d = await calculateDistance(
      currentPosition: currentPosition,
      hospitalLat: hospitalLat,
      hospitalLng: hospitalLng,
    );
    return d >= 1000
        ? '${(d / 1000).toStringAsFixed(1)} 公里'
        : '${d.toStringAsFixed(0)} 公尺';
  }

  Future<int> calculateWalkingTime({
    required LatLng currentPosition,
    required double hospitalLat,
    required double hospitalLng,
  }) async {
    final distanceMeters = await calculateDistance(
      currentPosition: currentPosition,
      hospitalLat: hospitalLat,
      hospitalLng: hospitalLng,
    );
    final timeSeconds = distanceMeters / walkingSpeedMetersPerSecond;
    return (timeSeconds / 60).round();
  }

  Future<void> navigateToHospital(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=walking',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('無法啟動導航：$url');
    }
  }
}
