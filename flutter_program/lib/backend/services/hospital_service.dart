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
import 'package:drw/backend/models/hospital.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

// 取得指定縣市的所有行政區
// city: 縣市名稱
// 回傳：行政區名稱的 List
class HospitalService {
  Future<List<String>> fetchDistricts(String city) async {
    final uri = Uri.parse(
        "${ApiBase.baseUrl}/getDistricts?city=$city"); //Uri.parse("${ApiBase.baseUrl}/addRemind");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<String>();
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      throw Exception(jsonDecode(response.body)['error']); // 找不到資料或請求錯誤
    } else {
      throw Exception('伺服器錯誤 (${response.statusCode})'); // 伺服器錯誤
    }
  }

  // 取得指定縣市、行政區的所有科別
  Future<List<String>> fetchDepartments(String city, String district) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/getDepartments?city=$city&district=$district');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body); // 解析伺服器回傳的 JSON
        return jsonData.cast<String>();
      } else {
        throw Exception(json.decode(response.body)['error'] ?? 'Unknown error');
      }
    } catch (e) {
      throw Exception('連線錯誤: $e'); // 連線錯誤，伺服器無法連線或超時
    }
  }

  Future<List<Map<String, dynamic>>> fetchHospitals({ // 依照縣市、行政區、科別查詢醫院
    required String city, // city 必填
    String district = '', // district 選填，預設空字串
    String dept = '', // dept 選填，預設空字串
  }) async {
    final uri =
        Uri.parse('${ApiBase.baseUrl}/getHospitals?city=$city&district=$district&dept=$dept');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body); // 回傳醫院資料
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('伺服器回應錯誤：${response.statusCode}');
      }
    } catch (e) {
      throw Exception('無法取得醫院資料：$e');
    }
  }
  // 取得距離使用者最近的醫院（單筆）
  Future<Hospital?> fetchNearestHospital(LatLng userLocation) async {
    final uri = Uri.parse(
      '${ApiBase.baseUrl}/hospitals/nearby'
      '?lat=${userLocation.latitude}&lng=${userLocation.longitude}',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isNotEmpty) {
          return Hospital.fromJson(jsonList.first); // 只取最近的第一筆資料
        }
        return null;
      } else {
        throw Exception('伺服器回應錯誤：${response.statusCode}');
      }
    } catch (e) {
      throw Exception('無法取得最近醫院：$e');
    }
  }

// 取得距離使用者最近的前 10 間醫院（多筆）
  Future<List<Hospital>> fetchHospitalsByDistance(LatLng userLocation) async {
    final uri = Uri.parse(
      '${ApiBase.baseUrl}/hospitals/nearby'
      '?lat=${userLocation.latitude}&lng=${userLocation.longitude}',
    );

    final res = await http.get(uri);
    debugPrint('Nearby 👉 $uri');
    debugPrint('→ status ${res.statusCode}, body=${res.body}');

    if (res.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(res.body); // 將每筆 JSON 轉換成 Hospital 物件
      return jsonList.map((j) => Hospital.fromJson(j)).toList();
    } else {
      throw Exception('無法取得附近醫院資料 (HTTP ${res.statusCode})');
    }
  }

}



