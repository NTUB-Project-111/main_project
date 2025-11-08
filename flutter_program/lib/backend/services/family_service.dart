import 'dart:convert';

import 'package:drw/backend/services/apibase.dart';
import 'package:http/http.dart' as http;

class FamilyService {
  Future<String?> addMember(
      {required int memberId,
      required int userId,
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
          'memberId': memberId,
          'userId': userId,
          'role': role,
          'birthyear': birthyear,
          'disease': disease,
          'freq': freq,
        }),
      );

      if (response.statusCode == 201) {
        return null; // 註冊成功
      } else {
        try {
          final data = jsonDecode(response.body);
          return data['message'] ?? '成員新增失敗';
        } catch (_) {
          return '成員新增失敗';
        }
      }
    } catch (e) {
      return '錯誤：$e';
    }
  }
}
