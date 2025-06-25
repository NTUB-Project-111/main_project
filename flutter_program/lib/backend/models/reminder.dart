import 'package:flutter/material.dart';
import 'report.dart';

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
    this.isEditing = false,
    String? selectedFreq,
    String? selectedTime,
  })  : selectedFreq = selectedFreq ?? initialFreq,
        selectedTime = selectedTime ?? initialTime;

  static Reminder fromReport(UserReport report) {
    final remind = report.reminds.isNotEmpty ? report.reminds.first : null;
    return Reminder(
      userId: report.userId,
      recordId: report.id,
      remindId: remind!.id,
      imagePath: report.photo,
      date: report.date,
      woundType: report.type,
      remindDate: remind.date,
      initialFreq: remind.freq,
      initialTime: remind.time, // 直接是 "08:30"
    );
  }

  /// 是否有被使用者修改過
  bool get isModified => selectedFreq != initialFreq || selectedTime != initialTime;

  /// 如果需要轉成 TimeOfDay 顯示用（例如開時間選擇器）
  TimeOfDay get selectedTimeOfDay => parseTime(selectedTime);

  /// 靜態工具函式
  static TimeOfDay parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  
}
