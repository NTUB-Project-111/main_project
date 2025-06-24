import 'package:flutter/material.dart';
import 'report.dart';

class Reminder {
  final String imagePath;
  final String date;
  final String woundType;
  final String remindDate;
  final String initialFreq;
  final TimeOfDay initialTime;
  bool isEditing;
  String selectedFreq;
  TimeOfDay selectedTime;

  Reminder({
    required this.imagePath,
    required this.date,
    required this.woundType,
    required this.remindDate,
    required this.initialFreq,
    required this.initialTime,
    this.isEditing = false,
    this.selectedFreq = '每天',
    this.selectedTime = const TimeOfDay(hour: 00, minute: 00),
  });

  static Reminder fromReport(UserReport report) {
    final remind = report.reminds.isNotEmpty ? report.reminds.first : null;
    return Reminder(
      imagePath: report.photo,
      date: report.date,
      woundType: report.type,
      remindDate: remind?.date ?? '',
      initialFreq: remind?.freq ?? '每天',
      initialTime: _parseTime(remind?.time ?? '00:00'),
      selectedFreq: remind?.freq ?? '每天',
      selectedTime: _parseTime(remind?.time ?? '00:00'),
    );
  }

  static TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool get isModified => selectedFreq != initialFreq || selectedTime != initialTime;

  void updateRemind() {
    if (selectedFreq != initialFreq) {
      //後端刪除再新增提醒
    } else {
      //後端修改提醒
    }
  }
}
