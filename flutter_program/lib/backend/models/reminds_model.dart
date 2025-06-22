import 'package:flutter/material.dart';

class UserRemind {
  int recordId;
  int remindId;
  String date = '';
  String time = '';
  String freq = '';

  UserRemind(
      {required this.recordId,
      required this.remindId,
      required this.date,
      required this.time,
      required this.freq});

  factory UserRemind.fromJson(Map<String, dynamic> json) {
    return UserRemind(
      recordId: json['fk_record_id'] ?? 0,
      remindId: json['id_calls'] ?? 0,
      date: json['day'] ?? '',
      time: json['time'] ?? '',
      freq: json['freq'] ?? '',
    );
  }

  @override
  String toString() {
    return '''
      === 提醒資料 === 
      recordId: $recordId
      提醒id: $remindId
      日期: $date
      時間: $time
      頻率: $freq
    ''';
  }
}

class Reminds with ChangeNotifier {
  List<UserRemind> _reminds = [];

  List<UserRemind> get reminds => _reminds;

  void setReminds(List<UserRemind> newReminds) {
    _reminds = newReminds;
    notifyListeners();
  }

}

