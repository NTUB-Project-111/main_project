import 'dart:convert';
import 'dart:io';
import 'package:drw/backend/models/records_model.dart';
import 'package:drw/backend/models/report.dart';
import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'apibase.dart';

class RecordService {
  /// 新增診斷紀錄
  Future<int?> addRecord(
    String fkUserid,
    String date,
    String type,
    String oktime,
    String caremode,
    String ifcall,
    String choosekind,
    String recording,
    String name,
    File photoFile,
  ) async {
    final uri = Uri.parse("${ApiBase.baseUrl}/addRecord");
    final request = http.MultipartRequest('POST', uri);
    // 表單資料
    request.fields['fk_userid'] = fkUserid;
    request.fields['date'] = date;
    request.fields['type'] = type;
    request.fields['oktime'] = oktime;
    request.fields['caremode'] = caremode;
    request.fields['ifcall'] = ifcall;
    request.fields['choosekind'] = choosekind;
    request.fields['recording'] = recording;
    request.fields['name'] = name;
    // 添加圖片檔案
    var mimeType = lookupMimeType(photoFile.path) ?? "image/jpeg"; // 確保有 MIME 類型
    var multipartFile = await http.MultipartFile.fromPath(
      'photo', // 這個 key 要跟後端 API 參數名稱一致
      photoFile.path,
      contentType: MediaType.parse(mimeType),
    );
    request.files.add(multipartFile);
    // 發送請求
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final Map<String, dynamic> responseBody = json.decode(responseData.body);
      final int recordId = responseBody['id_record'];
      debugPrint('上傳成功，record_id: $recordId');
      return recordId;
    } else {
      debugPrint('上傳失敗: HTTP ${response.statusCode}');
      return null;
    }
  }

  static Future<void> getRecords(BuildContext context, String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}/getRecords?id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List recordsJson = data['records'];
        final List<UserRecord> records =
            recordsJson.map((json) => UserRecord.fromJson(json)).toList();

        Provider.of<Records>(context, listen: false).setRecords(records);
        for (var record in records) {
          debugPrint('==========新的一筆record===========');
          debugPrint(record.recordId.toString());
          debugPrint(record.groupId.toString());
        }
      } else {
        debugPrint('取得紀錄失敗: ${response.statusCode}');
        debugPrint('錯誤訊息: ${response.body}');
      }
    } catch (e) {
      debugPrint('例外錯誤: $e');
    }
  }

  static Future<List<UserReport>> fetchReports(int userId) async {
    final url = Uri.parse('${ApiBase.baseUrl}/getRecordRemind?id=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> reportsJson = jsonData['reports'];

      return reportsJson.map((r) => UserReport.fromJson(r)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }

  Future<List<int>> fetchGroup(String userId) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/getGroup?userId=$userId');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];

          // 確保 data 是 List 並過濾掉 null，再轉為 int
          final List<int> groupList = (data is List)
              ? data.map((id) {
                  if (id == null || id.toString().trim().isEmpty) {
                    return 0;
                  } else {
                    return int.tryParse(id.toString()) ?? 0;
                  }
                }).toList()
              : [0];

          return groupList;
        } else {
          throw Exception('API 回傳失敗：${jsonResponse['message']}');
        }
      } else {
        throw Exception('HTTP 錯誤：${response.statusCode}');
      }
    } catch (e) {
      debugPrint('取得 group_id 時發生錯誤: $e');
      rethrow;
    }
  }

  Future<bool> updateGroupId(
    int userId,
    int recordId1,
    int recordId2,
    int groupId,
  ) async {
    final url = Uri.parse('${ApiBase.baseUrl}/updateGroupId');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'recordId1': recordId1,
          'recordId2': recordId2,
          'groupId': groupId,
        }),
      );
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        debugPrint('更新成功');
        return true;
      } else {
        debugPrint('更新失敗：${jsonResponse['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('發送更新請求時發生錯誤：$e');
      return false;
    }
  }

  Future<int?> fetchGroupId(
    int userId,
    int recordId,
  ) async {
    final uri = Uri.parse('${ApiBase.baseUrl}/getGroupId?userId=$userId&recordId=$recordId');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return data['groupId']; // 回傳 groupId 整數值
        } else {
          debugPrint('API 回傳失敗：${data['message']}');
        }
      } else {
        debugPrint('HTTP 錯誤：${response.statusCode}');
      }
    } catch (e) {
      debugPrint('取得 groupId 時發生錯誤：$e');
    }

    return null; // 若失敗則回傳 null
  }

  Future<void> updateOktime({
    required String userId,
    String? recordId,
    String? groupId,
    required String oktime,
    required String ifcall,
  }) async {
    final url = Uri.parse('${ApiBase.baseUrl}/updateOktime'); // 替換成你的伺服器網址

    final Map<String, dynamic> body = {
      'userId': userId,
      'oktime': oktime,
      if (recordId != null) 'recordId': recordId,
      if (groupId != null) 'groupId': groupId,
      'ifcall': ifcall
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          FrontUtil.showSuccess('更新成功');
        } else {
          FrontUtil.showFail('更新失敗：${responseData['message']}');
        }
      } else {
        FrontUtil.showFail('伺服器錯誤，狀態碼：${response.statusCode}');
      }
    } catch (e) {
      FrontUtil.showFail('請求失敗：$e');
    }
  }

  Future<bool> updateIfcall({
    required int userId,
    int? recordId,
    int? groupId,
    required String ifcall,
  }) async {
    final url = Uri.parse("${ApiBase.baseUrl}/updateIfcall");

    final body = {
      "userId": userId,
      "ifcall": ifcall,
    };

    if (groupId != null) {
      body["groupId"] = groupId;
    } else if (recordId != null) {
      body["recordId"] = recordId;
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      // 假設後端有回傳 { "success": true } 之類的格式
      return result["success"] == true;
    } else {
      return false;
    }
  }
}
