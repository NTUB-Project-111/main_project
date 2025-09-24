import 'dart:convert';
import 'package:drw/backend/models/hospital.dart'; // 醫院資料模型
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 讀取 .env 裡的 API key
import 'package:geolocator/geolocator.dart'; // 定位功能
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // HTTP 請求
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // 外部開啟 Google Map

enum OpenMarkerStyle { red, gray, star } // 定義 Marker 樣式：紅色 / 灰色 / 星星

class GoogleMapService extends ChangeNotifier {
  // 地圖狀態
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  static const double walkingSpeedMetersPerSecond = 1.4;

  // 收藏功能
  OpenMarkerStyle openMarkerStyle = OpenMarkerStyle.red; // 預設標記樣式：紅色
  final Set<int> _starredHospitalIds = {}; // 已收藏的醫院 ID
  String _userId = 'guest'; // 當前使用者 ID
  String _favKey(String uid) => 'fav_hospitals_$uid'; // 收藏儲存用 key

  bool isStarred(int hospitalId) => _starredHospitalIds.contains(hospitalId); // 判斷是否收藏
  Set<int> get starredIds => Set.unmodifiable(_starredHospitalIds); // 回傳收藏清單

// 從所有醫院中過濾出收藏的醫院
  List<Hospital> getStarredHospitals(List<Hospital> all) =>
      all.where((h) => _starredHospitalIds.contains(h.id)).toList();

// 初始化收藏資料
  Future<void> initFavorites({required String userId}) async {
    _userId = (userId.isEmpty) ? 'guest' : userId;
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favKey(_userId)) ?? const [];
    _starredHospitalIds
      ..clear()
      ..addAll(ids.map(int.parse));
    notifyListeners();
  }

  // 收藏 / 取消收藏
  void toggleStar(int hospitalId) {
    if (!_starredHospitalIds.add(hospitalId)) {
      _starredHospitalIds.remove(hospitalId);
    }
    _persistFavorites(); // 更新
    notifyListeners();
  }

// 儲存收藏清單到 SharedPreferences
  Future<void> _persistFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favKey(_userId),
      _starredHospitalIds.map((e) => e.toString()).toList(),
    );
  }

  //  載入自訂標記圖示 
  BitmapDescriptor? _iconGray;
  BitmapDescriptor? _iconRed;
  BitmapDescriptor? _iconStar;

  Future<void> _ensureIcons() async {
    if (_iconGray != null && _iconRed != null && _iconStar != null) return; // 如果都已經載過就不重複載
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
    } catch (_) {}
    // 如果圖片載入失敗，給預設顏色
    _iconRed ??= BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    _iconGray ??= BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

// Google Places 查營業狀態 
  String? get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY']; // 從 .env 讀取 API key

  
  Future<String?> getBusinessStatus({
    required String placeName,
    required double lat,
    required double lng,
  }) async {
    final key = _apiKey;
    if (key == null) return null;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
      'keyword=${Uri.encodeComponent(placeName)}'
      '&location=$lat,$lng'
      '&radius=100'
      '&key=$key',
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
      return null;
    }
  }

  //  在地圖上建立標記 
  Future<void> setMarkers(
    List<Hospital> hospitals,
    Function(Hospital) onMarkerTap,
    LatLng from, {
    required double pinColor, // 保留參數，不影響既有呼叫
  }) async {
    await _ensureIcons();

    final Set<Marker> next = {};

    await Future.wait(hospitals.map((h) async {
      if (h.latitude == 0.0 || h.longitude == 0.0) return;

     // 計算距離與步行時間
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

       // 查詢營業狀態
      h.openStatus = await getBusinessStatus(
        placeName: h.name,
        lat: h.latitude,
        lng: h.longitude,
      );
      final isOpen = h.openStatus == '營業中';

      // 收藏優先，其次營業狀態
      final starred = _starredHospitalIds.contains(h.id);
      final BitmapDescriptor icon =
          starred ? (_iconStar ?? _iconRed!) : (isOpen ? _iconRed! : _iconGray!);
      

      next.add(
        Marker(
          markerId: MarkerId(h.id.toString()),
          position: LatLng(h.latitude, h.longitude),
          infoWindow: InfoWindow(title: h.name, snippet: h.address),
          icon: icon,
          onTap: () => Future.microtask(() => onMarkerTap(h)),
        ),
      );
    }));

// 更新地圖標記
    _markers
      ..clear()
      ..addAll(next);
    notifyListeners();
  }

   // 建立 GoogleMap Widget 
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

 //  取得目前位置 
  Future<LatLng?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }
    return null;
  }

  // 計算距離 & 步行時間
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
    final d = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      hospitalLat,
      hospitalLng,
    );

    if (d >= 1000) {
      return '${(d / 1000).toStringAsFixed(1)} 公里';
    } else {
      return '${d.toStringAsFixed(0)} 公尺';
    }
  }

  // 步行時間（分鐘）
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

  // 導航
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
