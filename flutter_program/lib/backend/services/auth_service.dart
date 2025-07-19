import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'apibase.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  //傳送驗證碼
  Future<String?> sendCode(String email) async {
    final url = Uri.parse('${ApiBase.baseUrl}/sendCode');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        return null; // 成功，不回傳錯誤
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? '發送失敗';
      }
    } catch (e) {
      return '無法連線到伺服器';
    }
  }

  //驗證驗證碼
  Future<String?> verifyCode(String email, String code) async {
    final url = Uri.parse('${ApiBase.baseUrl}/verifyCode');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        // 驗證成功
        return null;
      } else {
        // 從後端回傳的錯誤訊息
        final body = jsonDecode(response.body);
        return body['message'] ?? '驗證失敗';
      }
    } catch (e) {
      return '連線錯誤：$e';
    }
  }

  //註冊帳號
  Future<String?> register({
    required String name,
    required String gender,
    required String birthday,
    required String email,
    required String password,
    required String disease,
    required String freq,
    File? imageFile,
  }) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/register');

    var request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name //..代表針對同一個物件(request)，連續呼叫多個方法或設定多個屬性
      ..fields['gender'] = gender
      ..fields['birthday'] = birthday
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['disease'] = disease
      ..fields['freq'] = freq;

    if (imageFile != null) {
      final fileName = path.basename(imageFile.path);
      final mimeType = 'image/${path.extension(fileName).replaceAll('.', '')}';
      debugPrint(mimeType);
      request.files.add(
        await http.MultipartFile.fromPath(
          'picture',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return null;
      } else {
        final data = jsonDecode(response.body);
        return data['message'] ?? '註冊失敗';
      }
    } catch (e) {
      return ('錯誤：$e');
    }
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data['accessToken'];
    } else {
      debugPrint(data['message']);
      throw Exception(data['message'] ?? '登入失敗');
    }
  }

  Future<Map<String, dynamic>> checkEmailExists(String email) async {
    final url = Uri.parse('${ApiBase.baseUrl}/exist');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return {
        'exists': result['exists'],
        'message': result['message'],
      };
    } else {
      final result = jsonDecode(response.body);
      return {
        'exists': false,
        'message': result['message'] ?? '發送錯誤，請檢察帳號是否輸入錯誤',
      };
    }
  }

  Future<String?> resetPassword(
    String email,
    String newPassword,
  ) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/resetPassword');
    try {
      debugPrint('送出 POST 請求到：$uri');
      debugPrint('請求內容：email=$email,  newPassword=$newPassword');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      debugPrint('收到回應：statusCode=${response.statusCode}');
      debugPrint('回應內容：${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return null; // 成功
      } else {
        return data['message'] ?? '未知錯誤';
      }
    } catch (e) {
      debugPrint('例外錯誤：$e');
      return '連線失敗：$e';
    }
  }
}
