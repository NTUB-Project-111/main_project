// // lib/api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// const String baseUrl = 'http://192.168.0.150:3000';


// class ApiService {
//   /// 取得縣市清單
//   static Future<List<String>> fetchCities() async {
//     final response = await http.get(Uri.parse('$baseUrl/api/cities'));
//     if (response.statusCode == 200) {
//       List<dynamic> jsonList = jsonDecode(response.body);
//       return jsonList.cast<String>();
//     } else {
//       throw Exception('載入城市失敗');
//     }
//   }

//   /// 取得地區清單（依縣市）
//   static Future<List<String>> fetchDistricts(String city) async {
//     final response = await http.get(Uri.parse('$baseUrl/api/districts?city=$city'));
//     if (response.statusCode == 200) {
//       List<dynamic> jsonList = jsonDecode(response.body);
//       return jsonList.cast<String>();
//     } else {
//       throw Exception('載入地區失敗');
//     }
//   }

//   /// 取得醫療部門清單（依縣市+地區）
//   static Future<List<String>> fetchDepartments(String city, String district) async {
//     final response = await http.get(Uri.parse('$baseUrl/api/departments?city=$city&district=$district'));
//     if (response.statusCode == 200) {
//       List<dynamic> jsonList = jsonDecode(response.body);
//       return jsonList.cast<String>();
//     } else {
//       throw Exception('載入部門失敗');
//     }
//   }

//   /// 取得醫院清單（依縣市/地區/部門）
// static Future<List<Map<String, dynamic>>> fetchHospitals({required String city, String district = '', String dept = ''}) async {
//   final uri = Uri.http(
//     '192.168.0.150:3000',
//     '/api/hospitals',
//     {
//       'city': city,
//       'district': district,
//       'dept': dept,
//     },
//   );
//   final response = await http.get(uri);
//   if (response.statusCode == 200) {
//     List<dynamic> jsonList = jsonDecode(response.body);
//     return List<Map<String, dynamic>>.from(jsonList);
//   } else {
//     throw Exception('載入醫院失敗');
//   }
// }
// }
