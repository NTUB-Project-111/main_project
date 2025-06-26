import 'package:flutter/material.dart';

class RemindUtil {
  static List<Map<String, dynamic>> createRemindList(
      String oktime, String shootDate, String remindFreq, String remindTime) {
    List<Map<String, dynamic>> remindList = [];
    //將shootDate轉換為日期格式
    DateTime shootingDate;
    try {
      shootingDate = DateTime.parse(shootDate); // 格式需為 yyyy-MM-dd
    } catch (e) {
      debugPrint("shootDate 格式錯誤: $shootDate");
      return [];
    }

    // 清理 oktime（移除空白與中文字）
    oktime = oktime
        .replaceAll(RegExp(r'\s+'), '') // 移除空白
        .replaceAll(RegExp(r'[\u4e00-\u9fa5]'), ''); // 移除中文

    final oktimelist = oktime.split("~");
    if (oktimelist.length < 2) {
      debugPrint("oktime 格式錯誤: $oktime");
      return [];
    }

    int okday = int.tryParse(oktimelist[1]) ?? 0;
    final freqMap = {
      "每天": 1,
      "兩天一次": 2,
      "三天一次": 3,
      "每週": 7,
    };
    final freqDays = freqMap[remindFreq] ?? 0;
    if (freqDays == 0) {
      debugPrint("不支援的提醒頻率: $remindFreq");
      return [];
    }

    //以今天作為起始日期
    final DateTime startDate = DateTime.now();
    final DateTime endDate = shootingDate.add(Duration(days: okday));
    DateTime remindDate = startDate.add(Duration(days: freqDays));

    while (!remindDate.isAfter(endDate)) {
      String remindDay = "${remindDate.year.toString().padLeft(4, '0')}-"
          "${remindDate.month.toString().padLeft(2, '0')}-"
          "${remindDate.day.toString().padLeft(2, '0')}";

      remindList.add({"day": remindDay, "time": remindTime});
      remindDate = remindDate.add(Duration(days: freqDays));
    }

    debugPrint(remindList.toString());
    return remindList;
  }
}
