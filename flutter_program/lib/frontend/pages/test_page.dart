// import 'package:drw/backend/models/testhospital.dart';
// import 'package:drw/backend/services/google_map.dart';
// import 'package:drw/backend/services/hospital_service.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class NearbyHospitalPage extends StatefulWidget {
//   const NearbyHospitalPage({super.key});

//   @override
//   State<NearbyHospitalPage> createState() => _NearbyHospitalPageState();
// }

// class _NearbyHospitalPageState extends State<NearbyHospitalPage> {
//   List<Testhospital> hospitals = [];
//   bool loading = true;
//   HospitalService hospitalService = HospitalService();
//   GoogleMapService googleMapService = GoogleMapService();

//   LatLng? _currentPosition;
//   final Set<Marker> _markers = {};
//   Testhospital? _selectedHospital; // 選取的醫院

//   @override
//   void initState() {
//     super.initState();
//     _loadHospitals();
//   }

//   Future<Position?> _getUserLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//       return null;
//     }
//     return Geolocator.getCurrentPosition();
//   }

//   Future<void> _loadHospitals() async {
//     try {
//       final position = await _getUserLocation();
//       if (position == null) {
//         setState(() => loading = false);
//         return;
//       }

//       _currentPosition = LatLng(position.latitude, position.longitude);

//       final list = await hospitalService.fetchNearbyHospitals(
//         position.latitude,
//         position.longitude,
//       );

//       final nearby = list.take(10).toList();

//       // 建立圖釘，並設定 onTap 事件
//       final markers = nearby.map((h) {
//         return Marker(
//           markerId: MarkerId(h.id.toString()),
//           position: LatLng(h.lat, h.lng),
//           onTap: () {
//             setState(() {
//               _selectedHospital = h;
//             });
//           },
//           infoWindow: InfoWindow(
//             title: h.name,
//             snippet: '${(h.distance / 1000).toStringAsFixed(2)} 公里\n${h.address}',
//           ),
//         );
//       }).toSet();

//       for (var h in nearby) {
//         h.openStatus = await googleMapService.fetchOpenStatus(h.id, h.lat, h.lng, h.name);
//       }

//       setState(() {
//         hospitals = nearby;
//         _markers.addAll(markers);
//         loading = false;
//       });
//     } catch (e) {
//       debugPrint('載入醫院失敗: $e');
//       setState(() => loading = false);
//     }
//   }

//   Widget _buildHospitalCard() {
//     if (_selectedHospital == null) return const SizedBox();
//     final h = _selectedHospital!;
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.all(16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(h.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Text(h.address),
//             const SizedBox(height: 4),
//             Text('電話：${h.phone}'),
//             const SizedBox(height: 4),
//             Text('距離：約 ${h.distance.toInt()} 公尺'),
//             const SizedBox(height: 4),
//             Text('營業狀態：${h.openStatus}'),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('最近十間醫院')),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : _currentPosition == null
//               ? const Center(child: Text('無法取得使用者座標'))
//               : Stack(
//                   children: [
//                     GoogleMap(
//                       initialCameraPosition: CameraPosition(
//                         target: _currentPosition!,
//                         zoom: 14,
//                       ),
//                       myLocationEnabled: true,
//                       markers: _markers,
//                     ),
//                     _buildHospitalCard(), // 顯示醫院資訊卡
//                   ],
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class PlaceStatusFromLatLngPage extends StatefulWidget {
  const PlaceStatusFromLatLngPage({super.key});

  @override
  State<PlaceStatusFromLatLngPage> createState() => _PlaceStatusFromLatLngPageState();
}

class _PlaceStatusFromLatLngPageState extends State<PlaceStatusFromLatLngPage> {
  final places = GoogleMapsPlaces(apiKey: "AIzaSyD-KhiOykQpJW11o5PquZcW1VfazentEq4");
  String statusMessage = "尚未查詢";

  /// Step 1: 用經緯度搜尋附近的店家，取得 Place ID
  Future<String?> _getNearbyPlaceId(double lat, double lng) async {
    final response = await places.searchNearbyWithRadius(
      Location(lat: lat, lng: lng),
      100, // 搜尋半徑（公尺），可以調整
    );

    if (response.status == "OK" && response.results.isNotEmpty) {
      return response.results.first.placeId; // 取最近的一個地點
    }
    return null;
  }

  /// Step 2: 用 Place ID 查營業狀態
  Future<void> getPlaceStatus(double lat, double lng) async {
    try {
      final placeId = await _getNearbyPlaceId(lat, lng);
      debugPrint(placeId);
      // if (placeId == null) {
      //   setState(() {
      //     statusMessage = "找不到附近的地點";
      //   });
      //   return;
      // }

      // final response = await places.getDetailsByPlaceId(placeId);

      // if (response.status == "OK") {
      //   final place = response.result;
      //   final isOpen = place.openingHours?.openNow;
      //   setState(() {
      //     if (isOpen == true) {
      //       statusMessage = "${place.name}：營業中";
      //     } else if (isOpen == false) {
      //       statusMessage = "${place.name}：休息中";
      //     } else {
      //       statusMessage = "${place.name}：沒有提供營業時間資訊";
      //     }
      //   });
      // } else {
      //   setState(() {
      //     statusMessage =
      //         "查詢失敗：${response.status} (${response.errorMessage ?? '無錯誤訊息'})";
      //   });
      // }
    } catch (e) {
      setState(() {
        statusMessage = "發生例外錯誤：$e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("經緯度查營業狀態")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(statusMessage, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 這裡測試：台北榮總附近經緯度
                getPlaceStatus(24.6671974, 121.6562);
              },
              child: const Text("查詢營業狀態"),
            ),
          ],
        ),
      ),
    );
  }
}
