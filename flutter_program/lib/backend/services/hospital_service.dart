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


//此檔案為「前端與後端的橋樑」。
//負責向伺服器發出請求、解析回傳的 JSON，並轉成 Flutter 可用的 Hospital 物件
// 引入必要套件

import 'dart:convert'; // 用於解析 JSON
import 'package:drw/backend/models/hospital.dart'; // 使用 Hospital 模型
import 'package:drw/backend/services/apibase.dart'; // 後端主機網址設定
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

// HospitalService 負責「呼叫後端 API」並取得醫院資料
class HospitalService {

  // 🔹 取得指定縣市的所有行政區清單
  // 輸入 city（縣市名稱），回傳行政區名稱清單
  Future<List<String>> fetchDistricts(String city) async {
    final uri = Uri.parse("${ApiBase.baseUrl}/getDistricts?city=$city"); // 組成查詢 URL
    final response = await http.get(uri); // 發送 GET 請求

    // 成功：將 JSON 陣列轉為 List<String>
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<String>();
    }
    // 錯誤處理
    else if (response.statusCode == 400 || response.statusCode == 404) {
      throw Exception(jsonDecode(response.body)['error']);
    } else {
      throw Exception('伺服器錯誤 (${response.statusCode})');
    }
  }

  // 🔹 取得指定縣市與行政區的「醫療科別」
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

  // 🔹 查詢醫院列表（依縣市、地區、科別）
  Future<List<Map<String, dynamic>>> fetchHospitals({
    required String city,
    String district = '',
    String dept = '',
  }) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/getHospitals?city=$city&district=$district&dept=$dept');
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

  // 🔹 取得距離使用者最近的單一醫院
  Future<Hospital?> fetchNearestHospital(LatLng userLocation) async {
    final uri = Uri.parse(
      '${ApiBase.baseUrl}/hospitals/nearby?lat=${userLocation.latitude}&lng=${userLocation.longitude}',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isNotEmpty) {
          return Hospital.fromJson(jsonList.first); // 轉成 Hospital 物件
        }
        return null;
      } else {
        throw Exception('伺服器回應錯誤：${response.statusCode}');
      }
    } catch (e) {
      throw Exception('無法取得最近醫院：$e');
    }
  }

  // 🔹 取得距離使用者最近的前 10 間醫院
  Future<List<Hospital>> fetchHospitalsByDistance(LatLng userLocation) async {
    final uri = Uri.parse(
      '${ApiBase.baseUrl}/hospitals/nearby?lat=${userLocation.latitude}&lng=${userLocation.longitude}',
    );

    final res = await http.get(uri);
    debugPrint('Nearby 👉 $uri');
    debugPrint('→ status ${res.statusCode}, body=${res.body}');

    if (res.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((j) => Hospital.fromJson(j)).toList();
    } else {
      throw Exception('無法取得附近醫院資料 (HTTP ${res.statusCode})');
    }
  }
}