import 'package:drw/backend/models/records_model.dart';
import 'package:drw/backend/models/reminds_model.dart';
import 'package:flutter/material.dart';

class Call extends ChangeNotifier {
  List<Map<String, dynamic>> reminders = [];

  void createReminders(List<UserRecord> userRecords,Map<int,List<UserRemind>> remindsMap) {
    reminders = userRecords.where((record) => record.ifcall == "Y").map((record) {
      return {
        "date": record.date,
        "type": record.type,
        "img": record.photo,
        "isPressed": false,
        "selectedFreq": remindsMap[record.recordId]?[0].freq,
        "selectedHour": int.parse(remindsMap[record.recordId]![0].time.split(":")[0]),
        "selectedMinute": int.parse(remindsMap[record.recordId]![0].time.split(":")[1]),
        "isDeleteView": false,
        "ifcall": true
      };
    }).toList();
  }

  /// 將提醒列表根據 recordId 分組成 Map<recordId, List<UserRemind>>
  Map<int, List<UserRemind>> getRemindsMap(List<UserRemind> reminds) {
    final Map<int, List<UserRemind>> map = {};
    for (var remind in reminds) {
      map.putIfAbsent(remind.recordId, () => []).add(remind);
    }
    return map;
  }
}
