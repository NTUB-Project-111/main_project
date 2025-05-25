import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class AuthService {
  //傳送驗證碼
  static Future<String> sendVerificationCode(String email) async {
    final url = Uri.parse("$baseUrl/forgotPassword");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['message'] ?? '已發送驗證碼';
      } else {
        return data['message'] ?? '發送失敗';
      }
    } catch (e) {
      return '伺服器錯誤: $e';
    }
  }

  static Future<String> sendCode(String email) async {
    final url = Uri.parse("$baseUrl/sendCode");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data['message'] ?? '已發送驗證碼';
      } else {
        return data['message'] ?? '發送失敗';
      }
    } catch (e) {
      return '伺服器錯誤: $e';
    }
  }

  //驗證使用者回傳的驗證碼是否正確
  static Future<String> verifyCode(String email, String code) async {
    final url = Uri.parse("$baseUrl/verifyResetCode");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data['message'] ?? '驗證成功';
      } else {
        return data['message'] ?? '驗證失敗';
      }
    } catch (e) {
      return '伺服器錯誤: $e';
    }
  }

  //修改新密碼
  static Future<String> resetPassword(String email, String code, String newPassword) async {
    final url = Uri.parse("$baseUrl/resetPassword");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code, 'newPassword': newPassword}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data['message'] ?? '密碼已更新';
      } else {
        return data['message'] ?? '變更失敗';
      }
    } catch (e) {
      return '伺服器錯誤: $e';
    }
  }
}
