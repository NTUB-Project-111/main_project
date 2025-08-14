import 'dart:convert';

import 'package:drw/backend/models/hospital_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// ---------- 1) 把 enum 放在檔案頂層（不要放在 class 裡） ----------
enum OpenMarkerStyle { red, gray, star }

class GoogleMapService extends ChangeNotifier {
  /// ---------- 2) 原本就有的欄位/常數 ----------
  final Set<Marker> _markers = {};
  static const double walkingSpeedMetersPerSecond = 1.4;

  /// 目前「營業中」的圖釘樣式（預設紅色）
  OpenMarkerStyle openMarkerStyle = OpenMarkerStyle.red;

  /// 提供 UI 切換的方法
  void setOpenMarkerStyle(OpenMarkerStyle style) {
    if (openMarkerStyle != style) {
      openMarkerStyle = style;
      notifyListeners();
    }
  }

  /// ---------- 3) 取得 Google 萬用 key ----------
  String? get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'];

  /// ---------- 4) 取得店家營業狀態 ----------
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

    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    if (data['results'] == null || (data['results'] as List).isEmpty) {
      return null;
    }

    final result = data['results'][0];
    final status = result['business_status'];
    if (status == 'CLOSED_PERMANENTLY') return '永久停業';
    if (status == 'CLOSED_TEMPORARILY') return '暫時停業';

    if (result['opening_hours']?['open_now'] != null) {
      final isOpenNow = result['opening_hours']['open_now'] as bool;
      return isOpenNow ? '營業中' : '已打烊';
    }
    return '狀態未知';
  }

  /// ---------- 5) 畫 Marker ----------
  Future<void> setMarkers(
    List<Hospital> hospitals,
    Function(Hospital) onMarkerTap,
    LatLng from, {
    required double pinColor,
  }) async {
    _markers.clear();

    // 你的自訂圖檔（灰/紅都用自己的）
    final BitmapDescriptor grayMarkerIcon =
        await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1.5),
      'images/gray_maker.png',
    );

    final BitmapDescriptor redMarkerIcon =
        await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1.5),
      'images/red_maker.png',
    );

    // ⭐ 新增星星圖檔
    final BitmapDescriptor starMarkerIcon =
        await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1.5),
      'images/star_marker.png',
    );

    await Future.wait(hospitals.map((hospital) async {
      if (hospital.latitude == 0.0 || hospital.longitude == 0.0) return;

      // 距離與步行時間
      hospital.distance = await calculateDistanceText(
        currentPosition: from,
        hospitalLat: hospital.latitude,
        hospitalLng: hospital.longitude,
      );
      hospital.walkTime = await calculateWalkingTime(
        currentPosition: from,
        hospitalLat: hospital.latitude,
        hospitalLng: hospital.longitude,
      );

      // 營業狀態（決定顏色/星星）
      hospital.openStatus = await getBusinessStatus(
        placeName: hospital.name,
        lat: hospital.latitude,
        lng: hospital.longitude,
      );
      final isOpen = hospital.openStatus == '營業中';

      // 依照 style 選 icon
      BitmapDescriptor openIcon = redMarkerIcon;
      switch (openMarkerStyle) {
        case OpenMarkerStyle.red:
          openIcon = redMarkerIcon;
          break;
        case OpenMarkerStyle.star:
          openIcon = starMarkerIcon;
          break;
        case OpenMarkerStyle.gray: // 很少用到：若你想「不論營業都灰」
          openIcon = grayMarkerIcon;
          break;
      }

      _markers.add(
        Marker(
          markerId: MarkerId(hospital.id.toString()),
          position: LatLng(hospital.latitude, hospital.longitude),
          infoWindow: InfoWindow(title: hospital.name, snippet: hospital.address),
          icon: isOpen ? openIcon : grayMarkerIcon,
          onTap: () => onMarkerTap(hospital),
        ),
      );
    }));

    notifyListeners();
  }

  Set<Marker> get markers => _markers;

  /// ---------- 6) 建立地圖 ----------
  Widget buildGoogleMap({
    required LatLng currentPosition,
    required Function(GoogleMapController) onMapCreated,
  }) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentPosition,
        zoom: 14,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) => onMapCreated(controller),
      markers: _markers,
    );
  }

  /// ---------- 7) 取得目前位置 ----------
  Future<LatLng?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }
    return null;
  }

  /// ---------- 8) 距離、時間 ----------
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
    return d >= 1000 ? '${(d / 1000).toStringAsFixed(1)} 公里' : '${d.toStringAsFixed(0)} 公尺';
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

  /// ---------- 9) 導航 ----------
  Future<void> navigateToHospital(double latitude, double longitude) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=walking',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('無法啟動導航：$googleMapsUrl');
    }
  }
}
