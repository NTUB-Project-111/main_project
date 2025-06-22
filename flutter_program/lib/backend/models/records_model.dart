import 'package:flutter/material.dart';

class UserRecord {
  int recordId;
  String date;
  String photo;
  String type;
  String oktime;
  String careSteps;
  String ifcall;
  String tags;
  String selfRecord;

  UserRecord({
    required this.recordId,
    required this.date,
    required this.photo,
    required this.type,
    required this.oktime,
    required this.careSteps,
    required this.ifcall,
    required this.tags,
    required this.selfRecord,
  });

  factory UserRecord.fromJson(Map<String, dynamic> json) {
    return UserRecord(
      recordId: json['id_record'] ?? 0,
      date: json['date'] ?? '',
      photo: json['photo'] ?? '',
      type: json['type'] ?? '',
      oktime: json['oktime'] ?? '',
      careSteps: json['caremode'] ?? '',
      ifcall: json['ifcall'] ?? '',
      tags: json['choosekind'] ?? '',
      selfRecord: json['recording'] ?? '',
    );
  }

  @override
  String toString() {
    return '''
      === 使用者資料 === 
      ID: $recordId
      日期: $date
      照片: $photo
      類型: $type
      OK時間: $oktime
      照護步驟: $careSteps
      是否提醒: $ifcall
      標籤: $tags
      自我紀錄: $selfRecord
    ''';
  }
}

class Records with ChangeNotifier {
  List<UserRecord> _records = [];

  List<UserRecord> get records => _records;

  void setRecords(List<UserRecord> newRecords) {
    _records = newRecords;
    notifyListeners();
  }

  void clearRecords() {
    _records = [];
    notifyListeners();
  }

  void addRecord(UserRecord newRecord) {
    _records.add(newRecord);
    notifyListeners();
  }
}
