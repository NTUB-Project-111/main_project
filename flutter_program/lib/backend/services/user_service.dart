import 'dart:convert';
import 'dart:io';
import 'package:drw/backend/models/user.dart';
import 'package:drw/backend/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'apibase.dart';
// import '../models/user_model.dart';

class UserService {
  // static Future<void> getUserInfo(BuildContext context, String accessToken) async {
  //   final response = await http.get(
  //     Uri.parse('${ApiBase.baseUrl}/getUserInfo'),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final userJson = data['user'];
  //     Provider.of<User>(context, listen: false).getFromJson(userJson);
  //   } else {
  //     debugPrint('錯誤代碼: ${response.statusCode}');
  //     debugPrint('錯誤訊息: ${response.body}');
  //   }
  // }
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
      final UserInfo userInfo = UserInfo.fromJson(userJson);
      Provider.of<UserProvider>(context, listen: false).setUserInfo(userInfo);
      // Provider.of<UserProvider>(context, listen: false).getFromJson(userJson);
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

  static Future<String?> updateImage({
    required int userId,
    required File imageFile,
  }) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/updateImage');
    final request = http.MultipartRequest('POST', uri);
    // 文字欄位
    request.fields['id'] = userId.toString();
    // 圖片檔案
    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    request.files.add(await http.MultipartFile.fromPath(
      'picture',
      imageFile.path,
      contentType: MediaType.parse(mimeType),
      filename: basename(imageFile.path),
    ));
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);

        // 從後端回傳中抓出新圖片路徑
        final newPath = jsonData['path'];
        debugPrint('✅ 新圖片路徑: $newPath');
        return newPath;
      } else {
        debugPrint('❌ 上傳失敗，狀態碼: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ 上傳錯誤: $e');
      return null;
    }
  }

  Future<bool> updateFreq({
    required int id,
    required String freq,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}/updateFreq'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'freq': freq}),
      );

      if (response.statusCode == 200) {
        // final data = jsonDecode(response.body);
        // print('伺服器回應: $data');
        return true; // 更新成功
      } else {
        // print('更新失敗: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      // print('發送請求時發生錯誤: $e');
      return false;
    }
  }

  Future<bool> updateDisease({
    required int id,
    required String disease,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}/updateDisease'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'disease': disease}),
      );
      if (response.statusCode == 200) {
        // final data = jsonDecode(response.body);
        // print('伺服器回應: $data');
        return true; // 更新成功
      } else {
        // print('更新失敗: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      // print('發送請求時發生錯誤: $e');
      return false;
    }
  }
}
