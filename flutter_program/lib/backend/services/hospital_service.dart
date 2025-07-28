// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:drw/backend/services/apibase.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../models/hospital_model.dart';

// class HospitalService {
//   Future<List<String>> fetchDistricts(String city) async {
//     final uri = Uri.parse(
//         "${ApiBase.baseUrl}/getDistricts?city=$city"); //Uri.parse("${ApiBase.baseUrl}/addRemind");
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonList = jsonDecode(response.body);
//       return jsonList.cast<String>();
//     } else if (response.statusCode == 400 || response.statusCode == 404) {
//       throw Exception(jsonDecode(response.body)['error']);
//     } else {
//       throw Exception('伺服器錯誤 (${response.statusCode})');
//     }
//   }

//   Future<List<String>> fetchDepartments(String city, String district) async {
//     final uri = Uri.parse(
//         '${ApiBase.baseUrl}/getDepartments?city=$city&district=$district');
//     try {
//       final response = await http.get(uri);
//       if (response.statusCode == 200) {
//         List<dynamic> jsonData = json.decode(response.body);
//         return jsonData.cast<String>();
//       } else {
//         throw Exception(json.decode(response.body)['error'] ?? 'Unknown error');
//       }
//     } catch (e) {
//       throw Exception('連線錯誤: $e');
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchHospitals({
//     required String city,
//     String district = '',
//     String dept = '',
//   }) async {
//     final uri = Uri.parse(
//         '${ApiBase.baseUrl}/getHospitals?city=$city&district=$district&dept=$dept');

//     try {
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.cast<Map<String, dynamic>>();
//       } else {
//         throw Exception('伺服器回應錯誤：${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('無法取得醫院資料：$e');
//     }
//   }

//   Future<List<Hospital>> fetchHospitalsByDistance(LatLng userLocation) async {
//     final uri = Uri.parse(
//       '${ApiBase.baseUrl}/hospitals/nearby'
//       '?lat=${userLocation.latitude}&lng=${userLocation.longitude}',
//     );

//     final response = await http.get(uri);
//     // 🔥 加 debugPrint 出來看看 statusCode / body
//     debugPrint('Nearby 👉 $uri');
//     debugPrint('→ status ${response.statusCode}, body=${response.body}');

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonList = json.decode(response.body);
//       return jsonList.map((j) => Hospital.fromJson(j)).toList();
//     } else {
//       throw Exception('無法取得附近醫院資料 (HTTP ${response.statusCode})');
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchHospitalsNearby({
//     required double lat,
//     required double lng,
//   }) async {
//     final uri =
//         Uri.parse('${ApiBase.baseUrl}/hospitals/nearby?lat=$lat&lng=$lng');

//     try {
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.cast<Map<String, dynamic>>();
//       } else {
//         throw Exception('伺服器回應錯誤：${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('無法取得附近醫院：$e');
//     }
//   }
// }

import 'dart:convert';
import 'package:drw/backend/services/apibase.dart';
import 'package:http/http.dart' as http;

class HospitalService {
  Future<List<String>> fetchDistricts(String city) async {
    final uri = Uri.parse(
        "${ApiBase.baseUrl}/getDistricts?city=$city"); //Uri.parse("${ApiBase.baseUrl}/addRemind");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<String>();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      throw Exception(jsonDecode(response.body)['error']);
    } else {
      throw Exception('伺服器錯誤 (${response.statusCode})');
    }
  }

  Future<List<String>> fetchDepartments(String city, String district) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/getDepartments?city=$city&district=$district');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<String>();
      } else {
        throw Exception(json.decode(response.body)['error'] ?? 'Unknown error');
      }
    } catch (e) {
      throw Exception('連線錯誤: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchHospitals({
    required String city,
    String district = '',
    String dept = '',
  }) async {
    final uri =
        Uri.parse('${ApiBase.baseUrl}/getHospitals?city=$city&district=$district&dept=$dept');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('伺服器回應錯誤：${response.statusCode}');
      }
    } catch (e) {
      throw Exception('無法取得醫院資料：$e');
    }
  }
}
