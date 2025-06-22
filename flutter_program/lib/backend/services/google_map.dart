import 'package:drw/backend/models/hospital_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class GoogleMapService extends ChangeNotifier {
  final Set<Marker> _markers = {};
  static const double walkingSpeedMetersPerSecond = 1.4;

  /// 向 Google Places API 查詢營業狀態
  Future<String?> getBusinessStatus({
    required String placeName,
    required double lat,
    required double lng,
  }) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null) return null;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
      'keyword=${Uri.encodeComponent(placeName)}'
      '&location=$lat,$lng'
      '&radius=100'
      '&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final result = data['results'][0];

        // 先確認是否仍在營運（沒有永久或暫時歇業）
        final status = result['business_status'];
        if (status == 'CLOSED_PERMANENTLY') return '永久停業';
        if (status == 'CLOSED_TEMPORARILY') return '暫時停業';

        // 再判斷是否當下有開門
        if (result['opening_hours']?['open_now'] != null) {
          bool isOpenNow = result['opening_hours']['open_now'];
          return isOpenNow ? '營業中' : '已打烊';
        }

        return '狀態未知';
      }
    }

    return null;
  }

  Future<void> setMarkers(
      List<Hospital> hospitals, Function(Hospital) onMarkerTap, LatLng from) async {
    _markers.clear();

    // 並行處理所有醫院的資訊與 marker 建立
    await Future.wait(hospitals.map((hospital) async {
      if (hospital.latitude != 0.0 && hospital.longitude != 0.0) {
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

        hospital.openStatus = await getBusinessStatus(
          placeName: hospital.name,
          lat: hospital.latitude,
          lng: hospital.longitude,
        );

        _markers.add(
          Marker(
            markerId: MarkerId(hospital.id.toString()),
            position: LatLng(hospital.latitude, hospital.longitude),
            infoWindow: InfoWindow(title: hospital.name, snippet: hospital.address),
            onTap: () => onMarkerTap(hospital),
          ),
        );
      }
    }));

    notifyListeners(); // 告知 UI 更新 markers
  }

  Set<Marker> get markers => _markers;

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

  /// 取得目前位置，若失敗則回傳 null
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

  /// 回傳目前位置到醫院的距離（單位：公尺）
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
    final double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      hospitalLat,
      hospitalLng,
    );

    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)} 公里';
    } else {
      return '${distance.toStringAsFixed(0)} 公尺';
    }
  }

  /// 計算步行時間（分鐘）
  Future<int> calculateWalkingTime({
    required LatLng currentPosition,
    required double hospitalLat,
    required double hospitalLng,
  }) async {
    // 先計算距離（公尺）
    double distanceMeters = await calculateDistance(
      currentPosition: currentPosition,
      hospitalLat: hospitalLat,
      hospitalLng: hospitalLng,
    );

    // 計算時間（秒）
    double timeSeconds = distanceMeters / walkingSpeedMetersPerSecond;

    // 轉換成分鐘，四捨五入取整數
    return (timeSeconds / 60).round();
  }

  /// 開啟 Google 地圖並導航至指定經緯度
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
