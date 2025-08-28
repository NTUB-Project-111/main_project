// // import 'package:drw/backend/models/hospital_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'dart:convert';
// // import 'package:url_launcher/url_launcher.dart';

// // class GoogleMapService extends ChangeNotifier {
// //   final Set<Marker> _markers = {};
// //   static const double walkingSpeedMetersPerSecond = 1.4;

// //   /// 向 Google Places API 查詢營業狀態
// //   Future<String?> getBusinessStatus({
// //     required String placeName,
// //     required double lat,
// //     required double lng,
// //   }) async {
// //     final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
// //     if (apiKey == null) return null;

// //     final url = Uri.parse(
// //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
// //       'keyword=${Uri.encodeComponent(placeName)}'
// //       '&location=$lat,$lng'
// //       '&radius=100'
// //       '&key=$apiKey',
// //     );

// //     final response = await http.get(url);
// //     if (response.statusCode == 200) {
// //       final data = json.decode(response.body);
// //       if (data['results'] != null && data['results'].isNotEmpty) {
// //         final result = data['results'][0];

// //         // 先確認是否仍在營運（沒有永久或暫時歇業）
// //         final status = result['business_status'];
// //         if (status == 'CLOSED_PERMANENTLY') return '永久停業';
// //         if (status == 'CLOSED_TEMPORARILY') return '暫時停業';

// //         // 再判斷是否當下有開門
// //         if (result['opening_hours']?['open_now'] != null) {
// //           bool isOpenNow = result['opening_hours']['open_now'];
// //           return isOpenNow ? '營業中' : '已打烊';
// //         }

// //         return '狀態未知';
// //       }
// //     }

// //     return null;
// //   }

// //   Future<void> setMarkers(
// //       List<Hospital> hospitals, Function(Hospital) onMarkerTap, LatLng from,
// //       {required double pinColor}) async {
// //     _markers.clear();

// //     // 載入灰色圖釘圖片
// //     final BitmapDescriptor grayMarkerIcon =
// //         await BitmapDescriptor.fromAssetImage(
// //       const ImageConfiguration(devicePixelRatio: 2.5),
// //       'images/gray_maker.png',
// //     );

// //     final BitmapDescriptor redMarkerIcon =
// //         BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

// //     await Future.wait(hospitals.map((hospital) async {
// //       if (hospital.latitude != 0.0 && hospital.longitude != 0.0) {
// //         hospital.distance = await calculateDistanceText(
// //           currentPosition: from,
// //           hospitalLat: hospital.latitude,
// //           hospitalLng: hospital.longitude,
// //         );

// //         hospital.walkTime = await calculateWalkingTime(
// //           currentPosition: from,
// //           hospitalLat: hospital.latitude,
// //           hospitalLng: hospital.longitude,
// //         );

// //         hospital.openStatus = await getBusinessStatus(
// //           placeName: hospital.name,
// //           lat: hospital.latitude,
// //           lng: hospital.longitude,
// //         );

// //         final isOpen = hospital.openStatus == '營業中';

// //         _markers.add(
// //           Marker(
// //             markerId: MarkerId(hospital.id.toString()),
// //             position: LatLng(hospital.latitude, hospital.longitude),
// //             infoWindow: InfoWindow(
// //               title: hospital.name,
// //               snippet: hospital.address,
// //             ),
// //             icon: isOpen ? redMarkerIcon : grayMarkerIcon,
// //             onTap: () => onMarkerTap(hospital),
// //           ),
// //         );
// //       }
// //     }));

// //     notifyListeners();
// //   }

// //   Set<Marker> get markers => _markers;

// //   Widget buildGoogleMap({
// //     required LatLng currentPosition,
// //     required Function(GoogleMapController) onMapCreated,
// //   }) {
// //     return GoogleMap(
// //       initialCameraPosition: CameraPosition(
// //         target: currentPosition,
// //         zoom: 14,
// //       ),
// //       myLocationEnabled: true,
// //       myLocationButtonEnabled: true,
// //       onMapCreated: (controller) => onMapCreated(controller),
// //       markers: _markers,
// //     );
// //   }

// //   late GoogleMapController _mapController;

// //   /// 取得目前位置，若失敗則回傳 null
// //   Future<LatLng?> getCurrentLocation() async {
// //     LocationPermission permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied ||
// //         permission == LocationPermission.deniedForever) {
// //       permission = await Geolocator.requestPermission();
// //     }

// //     if (permission == LocationPermission.whileInUse ||
// //         permission == LocationPermission.always) {
// //       final position = await Geolocator.getCurrentPosition();
// //       return LatLng(position.latitude, position.longitude);
// //     }

// //     return null;
// //   }

// //   /// 回傳目前位置到醫院的距離（單位：公尺）
// //   Future<double> calculateDistance({
// //     required LatLng currentPosition,
// //     required double hospitalLat,
// //     required double hospitalLng,
// //   }) async {
// //     return Geolocator.distanceBetween(
// //       currentPosition.latitude,
// //       currentPosition.longitude,
// //       hospitalLat,
// //       hospitalLng,
// //     );
// //   }

// //   Future<String> calculateDistanceText({
// //     required LatLng currentPosition,
// //     required double hospitalLat,
// //     required double hospitalLng,
// //   }) async {
// //     final double distance = Geolocator.distanceBetween(
// //       currentPosition.latitude,
// //       currentPosition.longitude,
// //       hospitalLat,
// //       hospitalLng,
// //     );

// //     if (distance >= 1000) {
// //       return '${(distance / 1000).toStringAsFixed(1)} 公里';
// //     } else {
// //       return '${distance.toStringAsFixed(0)} 公尺';
// //     }
// //   }

// //   /// 計算步行時間（分鐘）
// //   Future<int> calculateWalkingTime({
// //     required LatLng currentPosition,
// //     required double hospitalLat,
// //     required double hospitalLng,
// //   }) async {
// //     // 先計算距離（公尺）
// //     double distanceMeters = await calculateDistance(
// //       currentPosition: currentPosition,
// //       hospitalLat: hospitalLat,
// //       hospitalLng: hospitalLng,
// //     );

// //     // 計算時間（秒）
// //     double timeSeconds = distanceMeters / walkingSpeedMetersPerSecond;

// //     // 轉換成分鐘，四捨五入取整數
// //     return (timeSeconds / 60).round();
// //   }

// //   /// 開啟 Google 地圖並導航至指定經緯度
// //   Future<void> navigateToHospital(double latitude, double longitude) async {
// //     final googleMapsUrl = Uri.parse(
// //       'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=walking',
// //     );

// //     if (await canLaunchUrl(googleMapsUrl)) {
// //       await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
// //     } else {
// //       debugPrint('無法啟動導航：$googleMapsUrl');
// //     }
// //   }
// // }

// import 'package:drw/backend/models/hospital_model.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';


// class GoogleMapService extends ChangeNotifier {
//   final Set<Marker> _markers = {};
//   static const double walkingSpeedMetersPerSecond = 1.4;

//   /// 向 Google Places API 查詢營業狀態
//   Future<String?> getBusinessStatus({
//     required String placeName,
//     required double lat,
//     required double lng,
//   }) async {
//     final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
//     if (apiKey == null) return null;

//     final url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
//       'keyword=${Uri.encodeComponent(placeName)}'
//       '&location=$lat,$lng'
//       '&radius=100'
//       '&key=$apiKey',
//     );

//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['results'] != null && data['results'].isNotEmpty) {
//         final result = data['results'][0];

//         // 先確認是否仍在營運（沒有永久或暫時歇業）
//         final status = result['business_status'];
//         if (status == 'CLOSED_PERMANENTLY') return '永久停業';
//         if (status == 'CLOSED_TEMPORARILY') return '暫時停業';

//         // 再判斷是否當下有開門
//         if (result['opening_hours']?['open_now'] != null) {
//           bool isOpenNow = result['opening_hours']['open_now'];
//           return isOpenNow ? '營業中' : '已打烊';
//         }

//         return '狀態未知';
//       }
//     }

//     return null;
//   }

//   Future<void> setMarkers(
//       List<Hospital> hospitals, Function(Hospital) onMarkerTap, LatLng from) async {
//     _markers.clear();

//     // 並行處理所有醫院的資訊與 marker 建立
//     await Future.wait(hospitals.map((hospital) async {
//       if (hospital.latitude != 0.0 && hospital.longitude != 0.0) {
//         hospital.distance = await calculateDistanceText(
//           currentPosition: from,
//           hospitalLat: hospital.latitude,
//           hospitalLng: hospital.longitude,
//         );

//         hospital.walkTime = await calculateWalkingTime(
//           currentPosition: from,
//           hospitalLat: hospital.latitude,
//           hospitalLng: hospital.longitude,
//         );

//         hospital.openStatus = await getBusinessStatus(
//           placeName: hospital.name,
//           lat: hospital.latitude,
//           lng: hospital.longitude,
//         );

//         _markers.add(
//           Marker(
//             markerId: MarkerId(hospital.id.toString()),
//             position: LatLng(hospital.latitude, hospital.longitude),
//             infoWindow: InfoWindow(title: hospital.name, snippet: hospital.address),
//             onTap: () => onMarkerTap(hospital),
//           ),
//         );
//       }
//     }));

//     notifyListeners(); // 告知 UI 更新 markers
//   }

//   Set<Marker> get markers => _markers;

//   Widget buildGoogleMap({
//     required LatLng currentPosition,
//     required Function(GoogleMapController) onMapCreated,
//   }) {
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: currentPosition,
//         zoom: 14,
//       ),
//       myLocationEnabled: true,
//       myLocationButtonEnabled: true,
//       onMapCreated: (controller) => onMapCreated(controller),
//       markers: _markers,
//     );
//   }

//   /// 取得目前位置，若失敗則回傳 null
//   Future<LatLng?> getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
//       final position = await Geolocator.getCurrentPosition();
//       return LatLng(position.latitude, position.longitude);
//     }

//     return null;
//   }

//   /// 回傳目前位置到醫院的距離（單位：公尺）
//   Future<double> calculateDistance({
//     required LatLng currentPosition,
//     required double hospitalLat,
//     required double hospitalLng,
//   }) async {
//     return Geolocator.distanceBetween(
//       currentPosition.latitude,
//       currentPosition.longitude,
//       hospitalLat,
//       hospitalLng,
//     );
//   }

//   Future<String> calculateDistanceText({
//     required LatLng currentPosition,
//     required double hospitalLat,
//     required double hospitalLng,
//   }) async {
//     final double distance = Geolocator.distanceBetween(
//       currentPosition.latitude,
//       currentPosition.longitude,
//       hospitalLat,
//       hospitalLng,
//     );

//     if (distance >= 1000) {
//       return '${(distance / 1000).toStringAsFixed(1)} 公里';
//     } else {
//       return '${distance.toStringAsFixed(0)} 公尺';
//     }
//   }

//   /// 計算步行時間（分鐘）
//   Future<int> calculateWalkingTime({
//     required LatLng currentPosition,
//     required double hospitalLat,
//     required double hospitalLng,
//   }) async {
//     // 先計算距離（公尺）
//     double distanceMeters = await calculateDistance(
//       currentPosition: currentPosition,
//       hospitalLat: hospitalLat,
//       hospitalLng: hospitalLng,
//     );

//     // 計算時間（秒）
//     double timeSeconds = distanceMeters / walkingSpeedMetersPerSecond;

//     // 轉換成分鐘，四捨五入取整數
//     return (timeSeconds / 60).round();
//   }

//   /// 開啟 Google 地圖並導航至指定經緯度
//   Future<void> navigateToHospital(double latitude, double longitude) async {
//     final googleMapsUrl = Uri.parse(
//       'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=walking',
//     );

//     if (await canLaunchUrl(googleMapsUrl)) {
//       await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
//     } else {
//       debugPrint('無法啟動導航：$googleMapsUrl');
//     }
//   }
// }

import 'dart:convert';

import 'package:drw/backend/models/hospital_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum OpenMarkerStyle { red, gray, star }

class GoogleMapService extends ChangeNotifier {
  // --- map state ---
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  static const double walkingSpeedMetersPerSecond = 1.4;

  // --- 收藏（移出 extension，放回 class，避免「Extensions can't declare instance fields」） ---
  OpenMarkerStyle openMarkerStyle = OpenMarkerStyle.red;
  final Set<int> _starredHospitalIds = {};
  String _userId = 'guest';
  String _favKey(String uid) => 'fav_hospitals_$uid';

  bool isStarred(int hospitalId) => _starredHospitalIds.contains(hospitalId);
  Set<int> get starredIds => Set.unmodifiable(_starredHospitalIds);

  List<Hospital> getStarredHospitals(List<Hospital> all) =>
      all.where((h) => _starredHospitalIds.contains(h.id)).toList();

  Future<void> initFavorites({required String userId}) async {
    _userId = (userId.isEmpty) ? 'guest' : userId;
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favKey(_userId)) ?? const [];
    _starredHospitalIds
      ..clear()
      ..addAll(ids.map(int.parse));
    notifyListeners();
  }

  void toggleStar(int hospitalId) {
    if (!_starredHospitalIds.add(hospitalId)) {
      _starredHospitalIds.remove(hospitalId);
    }
    _persistFavorites();
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
    } catch (_) {}
    _iconRed ??= BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    _iconGray ??=
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

  String? get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'];

  /// Google Places 查營業狀態
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

  /// 建立地圖標記（含營業狀態 + 收藏圖示）
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

      // 距離 / 時間
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

      // 收藏優先，其次營業狀態
      final starred = _starredHospitalIds.contains(h.id);
      final BitmapDescriptor icon = starred
          ? (_iconStar ?? _iconRed!)
          : (isOpen ? _iconRed! : _iconGray!);

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

    _markers
      ..clear()
      ..addAll(next);
    notifyListeners();
  }

  /// GoogleMap Widget
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

  /// 定位
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

  /// 距離（公尺）
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

  /// 距離（文字）
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

  /// 步行時間（分鐘）
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

  /// 導航
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
