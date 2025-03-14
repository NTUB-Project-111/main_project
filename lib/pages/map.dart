

// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// const String googleMapsApiKey = "AIzaSyCDjOjWfvAM9JpXwMRdJVhKL77lCOfvezs"; 

// class HospitalListPage extends StatefulWidget {
//   const HospitalListPage({super.key});

//   @override
//   State<HospitalListPage> createState() => _HospitalListPageState();
// }

// class _HospitalListPageState extends State<HospitalListPage> {
//   final Location _locationController = Location();
//   List<Map<String, dynamic>> _hospitals = [];

//   @override
//   void initState() {
//     super.initState();
//     getLocationUpdates();
//   }

//   Future<void> getLocationUpdates() async {
//     bool serviceEnabled = await _locationController.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _locationController.requestService();
//       if (!serviceEnabled) return;
//     }

//     PermissionStatus permissionGranted =
//         await _locationController.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _locationController.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }

//     LocationData? currentLocation = await _locationController.getLocation();
//     if (currentLocation.latitude != null && currentLocation.longitude != null) {
//       fetchNearbyHospitals(
//           currentLocation.latitude!, currentLocation.longitude!);
//     }
//   }

//   Future<void> fetchNearbyHospitals(double lat, double lng) async {
//     String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
//         "?location=$lat,$lng"
//         "&radius=1000" // 搜尋 1 公里範圍內的醫院
//         "&type=hospital"
//         "&language=zh-TW"
//         "&key=$googleMapsApiKey";

//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       List hospitals = data['results'];
//       hospitals.sort((a, b) => a['geometry']['location']['lat']
//           .compareTo(b['geometry']['location']['lat']));
//       hospitals = hospitals.take(10).toList();

//       List<Map<String, dynamic>> hospitalList = [];
//       for (var hospital in hospitals) {
//         String name = hospital['name'];
//         String address = hospital['vicinity'] ?? "無地址資訊";
//         double hospitalLat = hospital['geometry']['location']['lat'];
//         double hospitalLng = hospital['geometry']['location']['lng'];

//         String distanceUrl =
//             "https://maps.googleapis.com/maps/api/distancematrix/json"
//             "?origins=$lat,$lng"
//             "&destinations=$hospitalLat,$hospitalLng"
//             "&mode=walking"
//             "&key=$googleMapsApiKey";

//         final distanceResponse = await http.get(Uri.parse(distanceUrl));
//         if (distanceResponse.statusCode == 200) {
//           final distanceData = json.decode(distanceResponse.body);
//           String distance =
//               distanceData['rows'][0]['elements'][0]['distance']['text'];
//           String duration =
//               distanceData['rows'][0]['elements'][0]['duration']['text'];
//           if (name.contains('醫院') && !name.contains('動物')) {
//             hospitalList.add({
//               'name': name,
//               'address': address,
//               'distance': distance,
//               'duration': duration,
//             });
//           }
//         }
//       }

//       setState(() {
//         _hospitals = hospitalList;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("附近醫院")),
//       body: _hospitals.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _hospitals.length,
//               itemBuilder: (context, index) {
//                 final hospital = _hospitals[index];
//                 return Card(
//                   margin:const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                   child: ListTile(
//                     title: Text(hospital['name'],
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("地址: ${hospital['address']}"),
//                         Text("距離: ${hospital['distance']}，步行時間: ${hospital['duration']}")
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
