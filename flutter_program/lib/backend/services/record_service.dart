import 'dart:convert';
import 'dart:io';
import 'package:drw/backend/models/records_model.dart';
import 'package:drw/backend/models/report.dart';
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
}
