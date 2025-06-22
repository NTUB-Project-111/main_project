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
