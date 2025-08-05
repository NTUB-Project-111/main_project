import 'dart:io';
import 'package:drw/backend/services/hospital_search.dart';
import 'package:drw/backend/services/careinfo_gpt.dart';
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
  // List<String> careSteps = [];
  Map<String, List<String>> careSteps = {};
  String gptResult = '';
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

  Future<void> _analyzeWoundImage(String birthday, String disease, String freq, bool isExtra,
      String? healTime, String? date, String? wound) async {
    Map<String, dynamic>? response = {};

    try {
      if (isExtra) {
        if (healTime == null) throw Exception('oktime 不應為 null');

        DateTime today = DateTime.now();
        int days = 0;
        if (date != null) {
          DateTime injuryDate = DateTime.parse(date);
          days = today.difference(injuryDate).inDays;
        }

        List<String> oktimeList = healTime.split('~');
        if (oktimeList.length < 2) throw Exception('oktime 格式錯誤，預期為 "7~14天"');

        // 僅擷取數字
        String rawStart = RegExp(r'\d+').stringMatch(oktimeList[0]) ?? '0';
        String rawEnd = RegExp(r'\d+').stringMatch(oktimeList[1]) ?? '0';

        List<int> intOktimeList = [0, 0];
        intOktimeList[0] = int.parse(rawStart) - days;
        intOktimeList[1] = int.parse(rawEnd) - days;

        // 不讓癒合時間出現負數
        intOktimeList = intOktimeList.map((d) => d < 0 ? 0 : d).toList();

        oktime = '${intOktimeList[0]}~${intOktimeList[1]}天';
        woundType = wound ?? '未知傷口';
        response =
            (await CareInfo.getCareSteps(wound!, birthday, disease, freq, isExtra, healTime, date));
      } else {
        final wound = await WoundAnalysis.analyzeWound(image!);
        // debugPrint(wound);
        woundType = wound;
        response =
            await CareInfo.getCareSteps(woundType, birthday, disease, freq, isExtra, oktime, date);
        debugPrint(response.toString());
        oktime = response != null ? (response['healingTime'] ?? '0') : '0';
      }
      careSteps = response?['careSteps'] ?? {};
      gptResult = response?['gptResult'] ?? {};

      // careSteps = response != null ? (response['steps']?.split('。') ?? []) : [];
      // debugPrint('============護理步驟=============');
      // debugPrint(careSteps.toString());
      // debugPrint(response!['steps']);
      // debugPrint(woundType);
      // careSteps = careSteps
      //     .map((e) => e
      //             .replaceAll(RegExp(r'^\d+\.'), '') // 移除開頭的數字+點，例如 1.、2.
      //             .replaceAll(RegExp(r'\s+'), '') // 移除所有空白、換行、tab
      //         )
      //     .where((e) => e.isNotEmpty)
      //     .toList();
      // for (int i = 0; i < careSteps.length; i++) {
      //   careSteps[i] = careSteps[i].replaceAll(RegExp(r'^\d+\.\s*'), '');
      // }
    } catch (e) {
      woundType = "分析失敗";
      careSteps = {
        "錯誤": ["$e"]
      };
    }
  }

  Future<void> _fetchHospitals() async {
    List<Map<String, dynamic>> hospitallist = await HospitalSearch.getNearbyHospitals();
    hospitals = hospitallist;
  }

  Future<void> loadData(String birthday, String disease, String freq, bool isExtra, String? oktime,
      String? date, String? woundType) async {
    debugPrint('$birthday\n$disease\n$freq');
    debugPrint(woundType);
    try {
      await Future.wait([
        // _fetchHospitals(),
        _analyzeWoundImage(birthday, disease, freq, isExtra, oktime, date, woundType)
      ]);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOktime(String birthday, String disease, String freq) async {
    isUpdating = true;
    notifyListeners();
    try {
      newOktime = await CareInfo.getOktime(woundType, injuryParts.toString(),
          woundReactions.toString(), selfRecord, birthday, disease, freq);
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
    int? id = await _record.addRecord(
        userId, date, woundType, oktime, gptResult, notify ? 'Y' : 'N', tags, selfRecord, image!);
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

  Future<bool> _addGroup(String userId, int id) async {
    bool result = true;
    final grouplist = await _record.fetchGroup(userId);
    debugPrint(grouplist.toString());
    if (grouplist.length == 1 && grouplist.first == 0) {
      //先顯查此使用者有沒有任何的group
      //沒有的話設定groupId為1
      result = await _record.updateGroupId(int.parse(userId), recordId, id, 1);
    } else {
      //有的話檢查選擇的照片有沒有設定群組
      final groupId = await _record.fetchGroupId(int.parse(userId), id);
      if (groupId != null) {
        //若已經有設定群組則沿用groupId
        result = await _record.updateGroupId(int.parse(userId), recordId, id, groupId);
      } else {
        final groupId = grouplist.reduce((a, b) => a > b ? a : b);
        result = await _record.updateGroupId(int.parse(userId), recordId, id, groupId + 1);
      }
    }
    return result;
  }

  Future<bool> uploadData(String userId, bool isExtra, int id) async {
    isSaving = true;
    notifyListeners();
    bool recordResult = true;
    bool remindResult = true;
    bool groupResult = true;
    recordResult = await _addRecord(userId);
    if (notify) remindResult = await _addRemind(userId);
    if (isExtra) {
      //建立群組
      groupResult = await _addGroup(userId, id);
    }
    isSaving = false;
    woundType = '';
    careSteps = {};
    oktime = '';
    hospitals = [];
    injuryParts = [];
    woundReactions = [];
    selfRecord = '';
    updateButton = false;
    newOktime = '';
    remindList = [];
    image = null;
    gptResult = '';
    notifyListeners();
    return recordResult && remindResult && groupResult;
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
