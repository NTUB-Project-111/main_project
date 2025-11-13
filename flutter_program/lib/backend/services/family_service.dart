import 'dart:convert';

import 'package:drw/backend/services/apibase.dart';
import 'package:http/http.dart' as http;

class FamilyService {
  //取得成員
  Future<List<dynamic>> getMembers(int userId) async {
    final url = Uri.parse('${ApiBase.baseUrl}/getMembers');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['members'];
    } else {
      throw Exception('Failed to load family members: ${response.body}');
    }
  }

  // 增加成員
  Future<Map<String, dynamic>?> addMember(
      {required int userId,
      required String role,
      required int birthyear,
      required String disease,
      required String freq}) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/addMember');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json', // 告訴後端這是 JSON
        },
        body: jsonEncode({
          'userId': userId,
          'role': role,
          'birthyear': birthyear,
          'disease': disease,
          'freq': freq,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'result': null, 'member': data['member']}; // 新增成員成功
      } else if (response.statusCode == 409) {
        return {'result': '該成員已存在', 'member': null};
      } else {
        try {
          return data['message'] ?? {'result': '成員新增失敗', 'member': null};
        } catch (_) {
          return {'result': '成員新增失敗', 'member': null};
        }
      }
    } catch (e) {
      return {'result': '錯誤：$e', 'member': null};
    }
  }
}
