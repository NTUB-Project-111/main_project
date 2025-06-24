import 'dart:convert';
import 'package:drw/backend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'apibase.dart';
import '../models/user_model.dart';

class UserService {
  static Future<void> getUserInfo(BuildContext context, String accessToken) async {
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/getUserInfo'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userJson = data['user'];
      Provider.of<User>(context, listen: false).getFromJson(userJson);
    } else {
      debugPrint('錯誤代碼: ${response.statusCode}');
      debugPrint('錯誤訊息: ${response.body}');
    }
  }

  Future<bool> updateUserName(String userId, String newName) async {
    final url = Uri.parse('${ApiBase.baseUrl}/updateName');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': userId,
          'name': newName,
        }),
      );
      if (response.statusCode == 200) {
        debugPrint('名稱更新成功');
        return true;
      } else {
        debugPrint('更新失敗: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('請求錯誤: $e');
      return false;
    }
  }

  Future<String?> verifyPassword(String id, String password) async {
    final url = Uri.parse('${ApiBase.baseUrl}/verifyPassword');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'password': password}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return null;
      } else {
        return data['message'];
      }
    } catch (e) {
      return '請求錯誤: $e';
    }
  }

  Future<String?> updatePassword(String id, String newPassword) async {
    final url = Uri.parse('${ApiBase.baseUrl}/updatePassword');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'password': newPassword}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return null;
      } else {
        return ('更新失敗: ${data['error']}');
      }
    } catch (e) {
      return ('請求錯誤: $e');
    }
  }

  static Future<UserInfo> fetchUserInfo(String token) async {
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/getUserDetail'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userJson = data['user'];
      userJson['reports'] = data['reports'];
      return UserInfo.fromJson(userJson);
    } else {
      throw Exception('取得使用者資料失敗: ${response.body}');
    }
  }
}
