import 'dart:io';
import 'package:drw/backend/services/hospital_search.dart';
import 'package:drw/backend/services/oktime_update.dart';
import 'package:drw/backend/services/record_service.dart';
import 'package:drw/backend/services/remind_service.dart';
import 'package:drw/backend/services/wound_analysis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Report extends ChangeNotifier {
  int recordId = 0;
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  File? image;
  String woundType = '';
  List<String> careSteps = [];
  String oktime = '';
  bool isLoading = true;
  bool notify = false;
  String remindFreq = '每天';
  String remindTime =
      "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
  List<Map<String, dynamic>> hospitals = [];
  List<String> injuryParts = [];
  List<String> woundReactions = [];
  bool open = false;
  String selfRecord = '';
  bool updateButton = false;
  bool isUpdating = false;
  String newOktime = '';
  bool isSaving = false;
  List<Map<String, dynamic>> remindList = [];

  final RecordService _record = RecordService();
  final RemindService _remind = RemindService();

  void setImage(File img) {
    image = img;
    notifyListeners();
  }

  void toggleNotify() {
    notify = !notify;
    notifyListeners();
  }

  void toggleOpen() {
    open = !open;
    notifyListeners();
  }

  void toggleUpdateButton() {
    updateButton = (injuryParts.isNotEmpty || woundReactions.isNotEmpty || selfRecord.isNotEmpty);
    notifyListeners();
  }

  void setSelfRecord(value) {
    selfRecord = value;
    notifyListeners();
  }

  void setInjuryParts(bool selected, String part) {
    if (selected) {
      injuryParts.add(part);
    } else {
      injuryParts.remove(part);
    }
    notifyListeners();
  }

  void setWoundReactions(bool selected, String part) {
    if (selected) {
      woundReactions.add(part);
    } else {
      woundReactions.remove(part);
    }
    notifyListeners();
  }

  void removeTags(String text, List<String> list) {
    list.remove(text);
    notifyListeners();
  }

  void _createRemindList() {
    remindList.clear();
    oktime = oktime
        .replaceAll(RegExp(r'\s+'), '') // 移除所有空白（空格、換行等）
        .replaceAll(RegExp(r'[\u4e00-\u9fa5]'), ''); // 移除所有中文字

    final oktimelist = oktime.split("~");
    int okday = int.parse(oktimelist[1]); // 正確轉換成 int
    final freqMap = {
      "每天": 1,
      "兩天一次": 2,
      "三天一次": 3,
      "每週": 7,
    };
    final freqDays = freqMap[remindFreq] ?? 0;
    List<String> parts = date.split('-');
    if (parts.length != 3) {
      debugPrint("日期格式錯誤: $date");
      return;
    }
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    DateTime startDate = DateTime(year, month, day);
    DateTime endDate = startDate.add(Duration(days: okday));
    DateTime remindDate = startDate.add(Duration(days: freqDays));
    while (!remindDate.isAfter(endDate)) {
      String remindDay = "${remindDate.year.toString().padLeft(4, '0')}-"
          "${remindDate.month.toString().padLeft(2, '0')}-"
          "${remindDate.day.toString().padLeft(2, '0')}";

      remindList.add({"day": remindDay, "time": remindTime});
      remindDate = remindDate.add(Duration(days: freqDays));
    }
    debugPrint(remindList.toString());
  }

  Future<void> _analyzeWoundImage() async {
    try {
      final result = await WoundAnalysis.analyzeWound(image!);
      woundType = result['woundType'];
      careSteps = result["careSteps"];
      oktime = result["oktime"];
    } catch (e) {
      woundType = "分析失敗";
      careSteps = ["錯誤: $e"];
    }
  }

  Future<void> _fetchHospitals() async {
    List<Map<String, dynamic>> hospitallist = await HospitalSearch.getNearbyHospitals();
    hospitals = hospitallist;
  }

  Future<void> loadData() async {
    try {
      // await Future.wait([_fetchHospitals(), _analyzeWoundImage()]);
      await Future.wait([_analyzeWoundImage()]);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOktime() async {
    isUpdating = true;
    notifyListeners();
    try {
      newOktime = await OktimeUpdate.getOktime(
          woundType, injuryParts.toString(), woundReactions.toString(), selfRecord);
      oktime = newOktime;
      notifyListeners();
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> _addRecord(String userId) async {
    final details = [
      injuryParts.toString(),
      woundReactions.toString(),
    ].toList();
    final tags = details
        .join(', ')
        .trim()
        .replaceAll(RegExp(r'^,|,$'), '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .trim()
        .replaceFirst(RegExp(r',$'), '');
    int? id = await _record.addRecord(userId, date, woundType, oktime, careSteps.toString(),
        notify ? 'Y' : 'N', tags, selfRecord, image!);
    if (id != null) {
      recordId = id;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _addRemind(String userId) async {
    bool result = true;
    _createRemindList();
    for (var remind in remindList) {
      result = await _remind.addRemind(userId, recordId.toString(), remind["day"].toString(),
          remind["time"].toString(), remindFreq);
      if (!result) {
        debugPrint("新增提醒失敗: $remind");
        return false;
      }
    }
    return result;
  }

  Future<bool> uploadData(String userId) async {
    isSaving = true;
    notifyListeners();
    bool recordResult = true;
    bool remindResult = true;
    recordResult = await _addRecord(userId);
    if (notify) remindResult = await _addRemind(userId);
    isSaving = false;
    notifyListeners();
    return recordResult && remindResult;
  }

  

  @override
  String toString() {
    return '''
      ===報告資訊===
      日期:$date
      照片:$image
      類型:$woundType
      癒合時間:$oktime
      護理步驟:$careSteps
      是否開啟提醒:$notify
      Tags:$injuryParts$woundReactions
      自我紀錄:$selfRecord
      頻率:$remindFreq
      時間:$remindTime
      =============
    ''';
  }
}
