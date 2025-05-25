import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class DatabaseHelper {
  static const String baseUrl = "http://192.168.100.2:3000"; //放自己電腦的IP
  // static final String userId;
  static Map<String, dynamic> calls = {};
  static Map<String, dynamic> record = {};
  static Map<String, dynamic> userInfo = {};
  static List<Map<String, dynamic>> allRecords = []; //取得使用者所有診斷紀錄
  static List<Map<String, dynamic>> allCalls = []; //取得使用者所有護理提醒
  static List<Map<String, dynamic>> remindRecords = []; //小鈴鐺護理提醒
  static List<Map<String, dynamic>> homeRemind = []; //首頁護理提醒

  // 存儲 userId
  static Future<bool> saveUserId(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$baseUrl/saveUserId?email=$email');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? userId = data['id']?.toString(); // 確保 userId 是字串或 null
        if (userId != null) {
          await prefs.setString('userId', userId);
          debugPrint('User ID 存儲成功: $userId');
          return true;
        }
      }
      debugPrint('無法獲取 User ID: ${response.statusCode} ${response.body}');
      return false;
    } catch (e) {
      debugPrint('請求錯誤: $e');
      return false;
    }
  }

  // 讀取 userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // 清除 userId
  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  // 取得使用者資訊
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');
    if (token == null) {
      debugPrint('無法取得 JWT Token');
      return null; // 若未取得 token，返回 null
    }
    final url = Uri.parse('$baseUrl/getUserInfo');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // 嘗試解析 JSON 資料並打印調試訊息
        try {
          final userInfo = jsonDecode(response.body);
          debugPrint('取得使用者資料: $userInfo'); // 可以打印來檢查返回資料
          return userInfo;
        } catch (e) {
          debugPrint('解析 JSON 錯誤: $e');
          return null;
        }
      } else {
        debugPrint('獲取使用者資料失敗: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('請求錯誤: $e');
      return null;
    }
  }

  //取得診斷報告
  static Future<List<Map<String, dynamic>>?> getUserRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = prefs.getString('jwtToken');
    if (userId == null || token == null) {
      debugPrint('無法取得 userId 或 JWT token，跳過請求');
      return null;
    }
    final url = Uri.parse('$baseUrl/getUserRecord?id=$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['records'] is List) {
          debugPrint('成功取得診斷紀錄，共 ${data['records'].length} 筆');
          return (data['records'] as List)
              .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
              .toList();
        } else {
          debugPrint('資料格式錯誤或 records 欄位不存在');
          return null;
        }
      } else {
        debugPrint('獲取使用者診斷紀錄失敗: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('請求錯誤: $e');
      return null;
    }
  }

  //取得護理提醒
  static Future<List<Map<String, dynamic>>?> getReminds() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = prefs.getString('jwtToken');

    if (userId == null || token == null) {
      debugPrint('無法取得 userId 或 JWT token，跳過請求');
      return null;
    }

    final url = Uri.parse('$baseUrl/getReminds?id=$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          debugPrint('成功取得提醒資料，共 ${data.length} 筆');
          return data
              .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
              .toList();
        } else {
          debugPrint('回傳資料格式錯誤，不是 List');
          return null;
        }
      } else {
        debugPrint('取得提醒失敗: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('請求錯誤: $e');
      return null;
    }
  }

  //取得護理提醒(結合診斷報告)
  static Future<List<Map<String, dynamic>>?> getRemindRecord() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = prefs.getString('jwtToken');

    if (userId == null || token == null) {
      debugPrint('無法取得 userId 或 JWT token，跳過請求');
      return null;
    }

    final url = Uri.parse('$baseUrl/getRemindRecord?id=$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          debugPrint('成功取得提醒與診斷紀錄，共 ${data.length} 筆');
          return data
              .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
              .toList();
        } else {
          debugPrint('回傳格式錯誤，非 List');
          return null;
        }
      } else {
        debugPrint('結合提醒與診斷資料失敗: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('請求錯誤: $e');
      return null;
    }
  }

  //取得首頁提醒
  static Future<List<Map<String, dynamic>>?> getHomeRemind() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = prefs.getString('jwtToken');

    if (userId == null || token == null) {
      debugPrint('無法取得 userId 或 JWT token，跳過請求');
      return null;
    }

    final url = Uri.parse('$baseUrl/getHomeRemind?id=$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          debugPrint('成功取得首頁提醒，共 ${data.length} 筆');
          return data
              .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
              .toList();
        } else {
          debugPrint('回傳格式錯誤，非 List');
          return null;
        }
      } else {
        debugPrint('獲取 HomeRemind 失敗: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('請求錯誤: $e');
      return null;
    }
  }

  // 刪除護理提醒
  static Future<bool> deleteRemind(String userId, String recordId) async {
    final url = Uri.parse('$baseUrl/deleteRemind');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fk_user_id': userId,
          'fk_record_id': recordId,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("提醒成功刪除");
        return true;
      } else {
        debugPrint("刪除失敗: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("刪除請求錯誤: $e");
      return false;
    }
  }

  /// 修改診斷報告
  static Future<bool> updateRecord(
      String idRecord, String fkUserId, String ifcall) async {
    final response = await http.post(
      Uri.parse("$baseUrl/updateRecord"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"id_record": idRecord, "fk_userid": fkUserId, "ifcall": ifcall}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// 修改提醒時間
  static Future<bool> updateCallTime(
      String idRecord, String fkUserId, String time) async {
    final response = await http.post(
      Uri.parse("$baseUrl/updateCallTime"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"fk_record_id": idRecord, "fk_user_id": fkUserId, "time": time}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

    //新增使用者
  static Future<bool> addUser(
    String name,
    String email,
    String password,
    String gender,
    String birthday,
    File? photoFile, // 改為 nullable（可選）
  ) async {
    var uri = Uri.parse("$baseUrl/addUser");
    var request = http.MultipartRequest("POST", uri);

    // 添加文字參數
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['gender'] = gender;
    request.fields['birthday'] = birthday;

    // 添加圖片檔案（只有當 photoFile 有內容且存在時）
    if (photoFile != null && await photoFile.exists()) {
      var mimeType = lookupMimeType(photoFile.path) ?? "image/jpeg";
      var multipartFile = await http.MultipartFile.fromPath(
        'photo',
        photoFile.path,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);
    }

    // 發送請求
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint("上傳失敗: ${response.body}");
      return false;
    }
  }

  /// 新增診斷紀錄（含圖片）
  static Future<bool> addRecord(
      String fkRecordId,
      String date,
      File photoFile, // 修改為 File 類型，確保可以讀取圖片檔案
      String type,
      String oktime,
      String caremode,
      String ifcall,
      String choosekind,
      String recording) async {
    var uri = Uri.parse("$baseUrl/addRecord");
    var request = http.MultipartRequest("POST", uri);

    // 添加文字參數
    request.fields['fk_userid'] = fkRecordId;
    request.fields['date'] = date;
    request.fields['type'] = type;
    request.fields['oktime'] = oktime;
    request.fields['caremode'] = caremode;
    request.fields['ifcall'] = ifcall;
    request.fields['choosekind'] = choosekind;
    request.fields['recording'] = recording;

    // 添加圖片檔案
    var mimeType =
        lookupMimeType(photoFile.path) ?? "image/jpeg"; // 確保有 MIME 類型
    var multipartFile = await http.MultipartFile.fromPath(
      'photo', // 這個 key 要跟後端 API 參數名稱一致
      photoFile.path,
      contentType: MediaType.parse(mimeType),
    );

    request.files.add(multipartFile);

    // 發送請求
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint("上傳失敗: ${response.body}"); // 記錄錯誤資訊
      return false;
    }
  }

  //護理提醒
  static Future<bool> addRemind(String fkUserId, String fkRecordId, String day,
      String time, String freq) async {
    if (fkUserId.isEmpty || day.isEmpty || time.isEmpty) {
      debugPrint("參數有空值: fk_user_id: $fkUserId, day: $day, time: $time");
      return false;
    }
    debugPrint("fk_user_id: $fkUserId, day: $day, time: $time");
    try {
      var uri = Uri.parse("$baseUrl/addRemind");
      var response = await http.post(
        uri,
        body: {
          'fk_user_id': fkUserId,
          'fk_record_id': fkRecordId,
          'day': day,
          'time': time,
          'freq': freq
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("上傳失敗: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("例外錯誤: $e");
      return false;
    }
  }

  //驗證密碼
  static Future<bool> verifyPassword(String email, String password) async {
    final url = Uri.parse("$baseUrl/verifyPassword");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('驗證成功：${responseData['message']}');
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        print('驗證失敗：${responseData['error']}');
        return false;
      }
    } catch (e) {
      print('請求錯誤：$e');
      return false;
    }
  }

  /// 修改名稱
  static Future<bool> updateName(String userId, String name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/updateName"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": userId, "name": name}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// 修改密碼
  static Future<bool> updatePassword(String userId, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/updatePassword"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": userId, "password": password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateImage(String userId, File image) async {
    try {
      var uri = Uri.parse("$baseUrl/updateImage");
      var request = http.MultipartRequest("POST", uri);
      request.fields['id'] = userId; // 添加使用者 ID
      var mimeType = lookupMimeType(image.path) ?? "image/jpeg"; // 確定 MIME 類型
      var multipartFile = await http.MultipartFile.fromPath(
        // 添加圖片檔案
        'image', // 這個 key 需要與後端 API `upload.single('image')` 一致
        image.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);
      var streamedResponse = await request.send(); // 發送請求
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("圖片更新失敗: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("圖片上傳發生錯誤: $e");
      return false;
    }
  }
}
