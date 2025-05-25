import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String googleMapsApiKey = "AIzaSyCDjOjWfvAM9JpXwMRdJVhKL77lCOfvezs";

class HospitalListPage extends StatefulWidget {
  const HospitalListPage({super.key});

  @override
  State<HospitalListPage> createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  final Location _locationController = Location();
  List<Map<String, dynamic>> _hospitals = [];

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData? currentLocation = await _locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      fetchNearbyHospitals(currentLocation.latitude!, currentLocation.longitude!);
    }
  }

  Future<void> fetchNearbyHospitals(double lat, double lng) async {
    String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=$lat,$lng"
        "&radius=2000" // 搜尋 2 公里範圍內的醫院
        "&type=hospital"
        "&language=zh-TW"
        "&key=$googleMapsApiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List hospitals = data['results'].take(5).toList(); // 取前 5 間醫院

      List<Map<String, dynamic>> hospitalList = [];
      for (var hospital in hospitals) {
        String name = hospital['name'];
        String address = hospital['vicinity'] ?? "無地址資訊";
        String placeId = hospital['place_id'];
        double hospitalLat = hospital['geometry']['location']['lat'];
        double hospitalLng = hospital['geometry']['location']['lng'];

        // 計算距離和步行時間
        String distanceUrl = "https://maps.googleapis.com/maps/api/distancematrix/json"
            "?origins=$lat,$lng"
            "&destinations=$hospitalLat,$hospitalLng"
            "&mode=walking"
            "&key=$googleMapsApiKey";

        final distanceResponse = await http.get(Uri.parse(distanceUrl));
        if (distanceResponse.statusCode == 200) {
          final distanceData = json.decode(distanceResponse.body);
          String distance = distanceData['rows'][0]['elements'][0]['distance']['text'];
          String duration = distanceData['rows'][0]['elements'][0]['duration']['text'];

          // 取得醫院詳細資訊（科別/診間）
          List<String> departments = await fetchHospitalDetails(placeId);

          hospitalList.add({
            'name': name,
            'address': address,
            'distance': distance,
            'duration': duration,
            'departments': departments,
          });
        }
      }

      setState(() {
        _hospitals = hospitalList;
      });
    }
  }
  Future<List<String>> fetchHospitalDetails(String placeId) async {
    String detailsUrl = "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId"
        "&fields=name,formatted_address,types,editorial_summary,reviews"
        "&language=zh-TW"
        "&key=$googleMapsApiKey";

    final response = await http.get(Uri.parse(detailsUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> departments = [];

      // **方法 1: 使用 types 來判斷科別**
      Map<String, String> typeMapping = {
        "hospital": "綜合醫院",
        "dentist": "牙科",
        "doctor": "診所",
        "physiotherapist": "復健科",
        "pharmacy": "藥局",
      };

      if (data['result']?['types'] != null) {
        for (var type in data['result']['types']) {
          if (typeMapping.containsKey(type)) {
            departments.add(typeMapping[type]!);
          }
        }
      }

      // **方法 2: 嘗試從 name 判斷**
      List<String> commonDepartments = ["內科", "外科", "骨科", "皮膚科", "牙科", "耳鼻喉科"];
      String hospitalName = data['result']['name'] ?? "";
      for (String dept in commonDepartments) {
        if (hospitalName.contains(dept)) {
          departments.add(dept);
        }
      }

      // **方法 3: 嘗試從 editorial_summary 找資訊**
      if (data['result']?['editorial_summary']?['overview'] != null) {
        String overview = data['result']['editorial_summary']['overview'];
        for (String dept in commonDepartments) {
          if (overview.contains(dept)) {
            departments.add(dept);
          }
        }
      }

      // 如果仍然沒有診間資訊，返回預設
      return departments.isNotEmpty ? departments : ["科別資訊不可用"];
    }
    return ["科別資訊不可用"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("附近醫院")),
      body: _hospitals.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _hospitals.length,
              itemBuilder: (context, index) {
                final hospital = _hospitals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(hospital['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("地址: ${hospital['address']}"),
                        Text("距離: ${hospital['distance']}，步行時間: ${hospital['duration']}"),
                        const SizedBox(height: 5),
                        Text(
                          "診間: ${hospital['departments'].join(", ")}",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
