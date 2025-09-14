import 'package:flutter/material.dart';
import '../models/report.dart';

class Reminder {
  final int userId;
  final int recordId;
  final int remindId;
  final String imagePath;
  final String date;
  final String woundType;
  final String remindDate;
  final String initialFreq;
  final String initialTime;
  final String oktime;
  bool isDelete;
  bool isEditing;
  String selectedFreq;
  String selectedTime;

  Reminder({
    required this.userId,
    required this.recordId,
    required this.remindId,
    required this.imagePath,
    required this.date,
    required this.woundType,
    required this.remindDate,
    required this.initialFreq,
    required this.initialTime,
    required this.oktime,
    required this.isDelete,
    this.isEditing = false,
    String? selectedFreq,
    String? selectedTime,
  })  : selectedFreq = selectedFreq ?? initialFreq,
        selectedTime = selectedTime ?? initialTime;

  static Reminder? fromReport(UserReport report) {
    final remind = report.reminds.isNotEmpty ? report.reminds.first : null;
    if (remind == null) {
      debugPrint('此 report（id=${report.id}）沒有提醒資料');
      return null;
    }

    return Reminder(
      userId: report.userId,
      recordId: report.id,
      remindId: remind.id,
      imagePath: report.photo,
      date: report.date,
      woundType: report.type,
      remindDate: remind.date,
      initialFreq: remind.freq,
      initialTime: remind.time,
      oktime: report.oktime,
      isDelete: false,
    );
  }

  /// 是否有被使用者修改過
  // bool get isModified => selectedFreq != initialFreq || selectedTime != initialTime || isDelete;
  bool isModifiedFlag = false;

  bool get isModified {
    return isModifiedFlag || selectedFreq != initialFreq || selectedTime != initialTime;
  }

  /// 如果需要轉成 TimeOfDay 顯示用（例如開時間選擇器）
  TimeOfDay get selectedTimeOfDay => parseTime(selectedTime);

  /// 靜態工具函式
  static TimeOfDay parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  
}
