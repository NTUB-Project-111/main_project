import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class ApiHelper {
  // 解 JWT 取得 payload
  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid token');
    final payload = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(payload));
    return jsonDecode(decoded);
  }

  // 檢查 token 是否過期
  static bool _isTokenExpired(String token) {
    try {
      final payload = _parseJwt(token);
      final exp = payload['exp'];
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  // 用 refresh token 換新 access token
  static Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    if (refreshToken == null) return false;

    final url = Uri.parse('$baseUrl/refreshToken');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newToken = data['token'];
      final newRefreshToken = data['refreshToken'];
      await prefs.setString('jwtToken', newToken);
      await prefs.setString('refreshToken', newRefreshToken);
      return true;
    } else {
      return false;
    }
  }

  // 帶自動續期的 GET 請求範例
  static Future<http.Response?> get(String path) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');

    if (token == null) {
      // 沒 token，通常要跳登入
      return null;
    }

    if (_isTokenExpired(token)) {
      final refreshed = await refreshToken();
      if (!refreshed) {
        // refresh token 也失效，跳登入
        return null;
      }
      token = prefs.getString('jwtToken');
    }

    final url = Uri.parse('$baseUrl$path');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
