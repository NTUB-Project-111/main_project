import 'dart:convert';
import 'package:drw/backend/models/reminds_model.dart';
import 'package:drw/backend/services/apibase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RemindService {
  Future<bool> addRemind(
      String fkUserId, String fkRecordId, String day, String time, String freq) async {
    if (fkUserId.isEmpty || day.isEmpty || time.isEmpty) {
      debugPrint("參數有空值: fk_user_id: $fkUserId, day: $day, time: $time");
      return false;
    }
    try {
      final uri = Uri.parse("${ApiBase.baseUrl}/addRemind");
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fk_user_id': fkUserId,
          'fk_record_id': fkRecordId,
          'day': day,
          'time': time,
          'freq': freq,
        }),
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

  static Future<void> getReminds(BuildContext context, String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}/getReminds?id=$userId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List recordsJson = data;
        final List<UserRemind> reminds = recordsJson.map((json) => UserRemind.fromJson(json)).toList();
        Provider.of<Reminds>(context, listen: false).setReminds(reminds);
      } else {
        debugPrint('取得提醒失敗: ${response.statusCode}');
        debugPrint('錯誤訊息: ${response.body}');
      }
    } catch (e) {
      debugPrint('例外錯誤: $e');
    }
  }
}
