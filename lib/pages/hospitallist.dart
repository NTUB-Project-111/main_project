
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HospitalSearch {
  static const String googleMapsApiKey = "AIzaSyCDjOjWfvAM9JpXwMRdJVhKL77lCOfvezs";

  static Future<List<Map<String, dynamic>>> getNearbyHospitals() async {
    try {
      Location location = Location();

      // 確保 GPS 服務可用
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return [];
      }

      // 確保有權限
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return [];
      }

      // 取得目前位置
      LocationData? currentLocation = await location.getLocation();
      if (currentLocation.latitude == null || currentLocation.longitude == null) return [];

      double lat = currentLocation.latitude!;
      double lng = currentLocation.longitude!;

      // 取得附近醫院
      String placesUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
          "?location=$lat,$lng"
          "&radius=2000"
          "&type=hospital"
          "&language=zh-TW"
          "&key=$googleMapsApiKey";

      final placesResponse = await http.get(Uri.parse(placesUrl));
      if (placesResponse.statusCode != 200) return [];

      final placesData = json.decode(placesResponse.body);
      List hospitals = placesData['results'];

      // 取得醫院清單（最多 10 間，避免 API 限制）
      List<Map<String, dynamic>> hospitalList = [];
      for (var hospital in hospitals.take(10)) {
        String name = hospital['name'];
        String address = hospital['vicinity'] ?? "無地址資訊";
        String placeId = hospital['place_id'];
        double hospitalLat = hospital['geometry']['location']['lat'];
        double hospitalLng = hospital['geometry']['location']['lng'];

        if (name.contains('醫院') && !name.contains('動物')) {
          hospitalList.add({
            'name': name,
            'address': address,
            'lat': hospitalLat,
            'lng': hospitalLng,
            'placeId': placeId,
          });
        }
      }

      if (hospitalList.isEmpty) return [];

      // 取得距離與步行時間
      String destinations = hospitalList
          .map((h) => "${h['lat']},${h['lng']}")
          .join('|');

      String distanceUrl = "https://maps.googleapis.com/maps/api/distancematrix/json"
          "?origins=$lat,$lng"
          "&destinations=$destinations"
          "&mode=walking"
          "&language=zh-TW"
          "&key=$googleMapsApiKey";

      final distanceResponse = await http.get(Uri.parse(distanceUrl));
      if (distanceResponse.statusCode != 200) return [];

      final distanceData = json.decode(distanceResponse.body);
      List elements = distanceData['rows'][0]['elements'];

      // 整合距離與步行時間
      for (int i = 0; i < hospitalList.length; i++) {
        hospitalList[i]['distance'] = elements[i]['distance']['value']; // 公尺
        hospitalList[i]['distanceText'] = elements[i]['distance']['text']; // 文字描述
        hospitalList[i]['duration'] = elements[i]['duration']['value']; // 秒
        hospitalList[i]['durationText'] = elements[i]['duration']['text']; // 文字描述
      }

      // 按距離排序，取最近的三間
      hospitalList.sort((a, b) => a['distance'].compareTo(b['distance']));
      List<Map<String, dynamic>> topHospitals = hospitalList.take(3).toList();

      // print(topHospitals);
      return topHospitals;
    } catch (e) {
      print("錯誤: $e");
      return [];
    }
  }
}
