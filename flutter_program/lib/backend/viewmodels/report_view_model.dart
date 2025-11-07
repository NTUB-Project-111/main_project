import 'dart:io';
import 'package:drw/backend/models/remind.dart';
import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/services/hospital_search.dart';
import 'package:drw/backend/services/careinfo_gpt.dart';
import 'package:drw/backend/services/record_service.dart';
import 'package:drw/backend/services/remind_service.dart';
import 'package:drw/backend/services/wound_analysis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Report extends ChangeNotifier {
  int userId = 0;
  int recordId = 0;
  int memberId = 0;
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
  List<String> imageUrls = [];
  List<String> steps = [];
  bool open = false;
  String selfRecord = '';
  bool updateButton = false;
  bool isUpdating = false;
  String newOktime = '';
  bool isSaving = false;
  bool isSwitch = false;
  String name = '';
  String imageUrl = '';
  String tags = '';
  int groupId = 0;
  List<Map<String, dynamic>> remindList = [];
  List<UserRemind> reminds = [];
  String role = '';
  String bruiseType = '';

  final RecordService _record = RecordService();
  final RemindService _remind = RemindService();
  void setName(String value) {
    name = value;
    notifyListeners();
  }

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

  void toggleSwitch() {
    isSwitch = !isSwitch;
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

  void setRole(String value) {
    role = value;
    notifyListeners();
  }

  void removeTags(String text, List<String> list) {
    list.remove(text);
    notifyListeners();
  }

  void _createRemindList() {
    // debugPrint(oktime);
    // debugPrint(remindFreq);
    // debugPrint(remindTime);
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
    // debugPrint(remindList.toString());
  }

  List<String> getReference(bool isExtra) {
    List<String> reference = [];
    if (isExtra) {
      switch (woundType) {
        case '燒傷':
        case '燙傷':
          reference = [
            'https://www.weigong.org.tw/HealthEdus/Detail?no=133',
            'https://yl.cch.org.tw/upload/knowledge/251/2024%E5%B9%B412%E6%9C%8859560-P-C-050-03%E7%87%99%E7%87%92%E5%82%B7%E5%8F%A3%E8%AD%B7%E7%90%86%E9%A0%88%E7%9F%A5_6564428.pdf',
            'https://ihealth.vghtpe.gov.tw/media/345'
          ];
          break;
        case '擦傷':
        case '割傷':
        case '刺傷':
          reference = [
            'https://www.kentcht.nhs.uk/leaflet/changing-your-wound-dressing/',
            'https://patient.uwhealth.org/healthfacts/6820'
          ];
          break;
        case '瘀青':
          reference = [
            'https://www.stanfordchildrens.org/en/topic/default?id=bruises-90-P02795',
            'https://my.clevelandclinic.org/health/diseases/15235-bruises',
            'https://www.mayoclinic.org/first-aid/first-aid-bruise/basics/art-20056663'
          ];
          break;
        case '手術傷口':
          reference = [
            'https://ihealth.vghtc.gov.tw/media/886',
            'https://www.chimei.org.tw/main/cmh_department/59012/info/7510/A7510213.html',
            'https://www1.cgmh.org.tw/intr/intr4/c8270/Sports%20Medicine%20Center_health/00383-20220806-140132.pdf'
          ];
          break;
        default:
          reference = [];
      }
    } else {
      switch (woundType) {
        case '燒傷':
        case '燙傷':
          reference = [
            'https://www.nhs.uk/conditions/burns-and-scalds/',
            'https://www.mayoclinic.org/first-aid/first-aid-burns/basics/art-20056649',
            'https://www.auh.org.tw/NewsInfo/HealthEducationInfo?docid=1241'
          ];
          break;
        case '擦傷':
          reference = [
            'https://www.stanfordchildrens.org/en/topic/default?id=abrasions-90-P02789',
            'https://newsnetwork.mayoclinic.org/discussion/treating-skin-abrasions-known-as-raspberries/',
            'https://intermountainhealthcare.org/blogs/4-steps-to-treat-abrasions-at-home'
          ];
          break;
        case '割傷':
          reference = [
            'https://www.nhs.uk/conditions/cuts-and-grazes/',
            'https://www.mayoclinic.org/zh-hans/first-aid/first-aid-cuts/basics/art-20056711',
            'https://www.stanfordchildrens.org/en/topic/default?id=taking-care-of-cuts-and-scrapes-1-2978'
          ];
          break;
        case '刺傷':
          reference = [
            'https://www.mayoclinic.org/first-aid/first-aid-puncture-wounds/basics/art-20056665',
            'https://www.stanfordchildrens.org/en/topic/default?id=puncture-wounds-90-P02844',
            'https://medlineplus.gov/ency/article/000043.htm'
          ];
          break;
        case '瘀青':
          reference = [
            'https://www.stanfordchildrens.org/en/topic/default?id=bruises-90-P02795',
            'https://my.clevelandclinic.org/health/diseases/15235-bruises',
            'https://www.mayoclinic.org/first-aid/first-aid-bruise/basics/art-20056663'
          ];
          break;
        case '手術傷口':
          reference = [
            'https://ihealth.vghtc.gov.tw/media/886',
            'https://www.chimei.org.tw/main/cmh_department/59012/info/7510/A7510213.html',
            'https://www1.cgmh.org.tw/intr/intr4/c8270/Sports%20Medicine%20Center_health/00383-20220806-140132.pdf'
          ];
          break;
        default:
          reference = [];
      }
    }
    return reference;
  }

  void getImages(bool isExtra) {
    if (isExtra) {
      switch (woundType) {
        case '燒傷':
        case '燙傷':
          imageUrls = [
            'images/burncare1.png',
            'images/burncare2.png',
            'images/burncare3.png',
            'images/burncare4.png',
            'images/burncare5.png',
            'images/burncare6.png',
            'images/burncare7.png'
          ];
          steps = ['洗手', '移除舊紗布', '觀察傷口', '清潔傷口', '擦乾傷口', '擦藥', '包紮傷口'];
          break;
        case '擦傷':
        case '割傷':
        case '刺傷':
          imageUrls = [
            'images/woundcare1.png',
            'images/woundcare2.png',
            'images/woundcare3.png',
            'images/woundcare4.png',
            'images/woundcare5.png'
          ];
          steps = ['洗淨雙手', '拆除舊敷料', '擦拭傷口', '塗抹藥膏', '包紮傷口'];
          break;
        case '瘀青':
          imageUrls = [
            'images/bruise1.jpg',
            'images/bruise2.jpg',
            'images/bruise3.jpg',
            'images/bruise4.jpg',
            'images/bruise5.jpg'
          ];
          steps = ['初期冷敷', '後期熱敷', '避免加壓或按摩', '抬高患肢', '若瘀傷部位出現腫脹'];
          break;
        case '手術傷口':
          imageUrls = [
            'images/surgical1.png',
            'images/surgical2.png',
            'images/surgical3.png',
            'images/surgical4.png',
            'images/surgical5.png',
            'images/surgical1.png',
          ];
          steps = ['清潔雙手', '檢查傷口', '清潔傷口', '消毒傷口', '包紮傷口', '再次洗手'];
          break;
        case '嚴重傷口':
          imageUrls = [
            'images/serious1.png',
            'images/serious2.png',
            'images/serious3.png',
            'images/serious4.png',
            'images/serious5.png',
          ];
          steps = ['盡快送醫', '立刻加壓止血', '抬高患部', '避免進食與飲水', '保持溫暖、防休克'];
          break;
        default:
          imageUrls = [];
      }
    } else {
      switch (woundType) {
        case '燒傷':
        case '燙傷':
          imageUrls = [
            'images/burn1.png',
            'images/burn2.png',
            'images/burn3.png',
            'images/burn4.png',
            'images/burn5.png'
          ];
          steps = ['沖洗燒燙傷部位', '脫掉衣物飾品', '浸泡傷部', '塗抹乳液', '包紮傷口', '服用止痛藥(如有需要)'];
          break;
        case '擦傷':
          imageUrls = [
            'images/abrasion1.png',
            'images/abrasion2.png',
            'images/abrasion3.png',
            'images/abrasion4.png'
          ];
          steps = ['洗淨雙手', '清潔傷口', '擦藥', '包紮傷口'];
          break;
        case '割傷':
          imageUrls = [
            'images/cut1.png',
            'images/cut2.png',
            'images/cut3.png',
            'images/cut4.png',
            'images/cut5.png'
          ];
          steps = ['洗手', '止血', '清潔傷口', '塗抹藥膏', '包紮傷口'];
          break;
        case '刺傷':
          imageUrls = [
            'images/stab1.png',
            'images/stab2.png',
            'images/stab3.png',
            'images/stab4.png',
            'images/stab5.png'
          ];
          steps = ['洗手', '止血', '清潔傷口', '塗抹藥膏', '覆蓋傷口'];
          break;
        case '瘀青':
          imageUrls = [
            'images/bruise1.jpg',
            'images/bruise2.jpg',
            'images/bruise3.jpg',
            'images/bruise4.jpg',
            'images/bruise5.jpg'
          ];
          steps = ['初期冷敷', '後期熱敷', '避免加壓或按摩', '抬高患肢', '若瘀傷部位出現腫脹'];
          break;
        case '手術傷口':
          imageUrls = [
            'images/surgical1.png',
            'images/surgical2.png',
            'images/surgical3.png',
            'images/surgical4.png',
            'images/surgical5.png',
            'images/surgical1.png',
          ];
          steps = ['清潔雙手', '檢查傷口', '清潔傷口', '消毒傷口', '包紮傷口', '再次洗手'];
          break;
        case '嚴重傷口':
          imageUrls = [
            'images/serious1.png',
            'images/serious2.png',
            'images/serious3.png',
            'images/serious4.png',
            'images/serious5.png',
          ];
          steps = ['盡快送醫', '立刻加壓止血', '抬高患部', '避免進食與飲水', '保持溫暖、防休克'];
          break;
        default:
          imageUrls = [];
      }
    }
  }

  Future<void> _analyzeWoundImage(
      String birthday, String disease, String freq, bool isExtra, UserReport? report) async {
    Map<String, dynamic>? response = {};

    try {
      if (isExtra) {
        name = '${report!.type}診斷報告'.replaceAll(RegExp(r'\s+'), '');
        DateTime today = DateTime.now();
        int days = 0;
        DateTime injuryDate = DateTime.parse(report.date);
        days = today.difference(injuryDate).inDays;

        List<String> oktimeList = report.oktime.split('~');
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
        woundType = report.type;

        response = (await CareInfo.getCareSteps(woundType, birthday, disease, freq, isExtra, days));
      } else {
        final wound = await WoundAnalysis.analyzeWound(image!);
        woundType = wound;
        name = '$woundType診斷報告'.replaceAll(RegExp(r'\s+'), '');
        if (woundType != '無異常') {
          response = await CareInfo.getCareSteps(woundType, birthday, disease, freq, isExtra, 0);
          // debugPrint(response.toString());
          oktime = response != null ? (response['healingTime'] ?? '0') : '0';
        } else if (woundType == '無異常') {
          return;
        }
      }
      careSteps = response?['careSteps'] ?? {};
      gptResult = response?['gptResult'] ?? {};
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

  // AI生成圖片
  // Future<void> _generateImages() async {
  //   steps = careSteps.entries.map((e) => e.key).toList();
  //   RecordService recordService = RecordService();
  //   imageUrls = await recordService.generateImages(steps);
  // }

  Future<void> loadData(int userId, String birthday, String disease, String freq, bool isExtra,
      UserReport? report) async {
    // debugPrint('$birthday\n$disease\n$freq');
    this.userId = userId;
    try {
      await Future.wait([
        // _fetchHospitals(),
        _analyzeWoundImage(birthday, disease, freq, isExtra, report),
      ]);
      // await _generateImages();
      getImages(isExtra);
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

  Future<bool> addRecord() async {
    final details = [
      injuryParts.toString(),
      woundReactions.toString(),
    ].toList();
    tags = details
        .join(', ')
        .trim()
        .replaceAll(RegExp(r'^,|,$'), '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .trim()
        .replaceFirst(RegExp(r',$'), '');
    name == '' ? '$woundType診斷報告' : name;
    // final result1 = await _record.fetchMemberId(userId);
    // memberId = result1 ?? 1;
    final result2 = await _record.addRecord(userId.toString(), date, woundType, oktime, gptResult,
        notify ? 'Y' : 'N', tags, selfRecord, name, image!,memberId);
    int? id = result2?['recordId'];
    imageUrl = result2?['imageUrl'] ?? '';
    if (id != null) {
      recordId = id;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addRemind(String userId) async {
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

  Future<bool> _addGroup(int id, UserReport report) async {
    bool result = true;
    final grouplist = await _record.fetchGroup(userId.toString());
    // debugPrint("===========grouplist=============");
    // debugPrint(grouplist.toString());
    if (grouplist.length == 1 && grouplist.first == 0) {
      //先顯查此使用者有沒有任何的group
      //沒有的話設定groupId為1
      groupId = 1;
      report = report.copyWith(groupId: groupId);
      result = await _record.updateGroupId(userId, recordId, id, 1);
      // debugPrint('舊報告groupID${report.groupId.toString()}');
      // debugPrint('新報告groupID${report.groupId.toString()}');
    } else {
      //有的話檢查選擇的照片有沒有設定群組
      final groupId = await _record.fetchGroupId(userId, id);
      if (groupId != null) {
        //若已經有設定群組則沿用groupId
        this.groupId = groupId;
        report = report.copyWith(groupId: this.groupId);
        result = await _record.updateGroupId(userId, recordId, id, groupId);
      } else {
        final groupId = grouplist.reduce((a, b) => a > b ? a : b);
        result = await _record.updateGroupId(userId, recordId, id, groupId + 1);
        this.groupId = groupId + 1;
        report = report.copyWith(groupId: this.groupId);
      }
    }
    return result;
  }

  Future<bool> uploadData(String userId, bool isExtra, int id, UserReport? report) async {
    isSaving = true;
    notifyListeners();
    bool recordResult = true;
    bool remindResult = true;
    bool groupResult = true;
    recordResult = await addRecord();
    if (notify) remindResult = await addRemind(userId);
    if (isExtra) {
      //建立群組
      groupResult = await _addGroup(id, report!);
    }
    // isSaving = false;
    // woundType = '';
    // careSteps = {};
    // oktime = '';
    // hospitals = [];
    // injuryParts = [];
    // woundReactions = [];
    // selfRecord = '';
    // updateButton = false;
    // newOktime = '';
    // remindList = [];
    // image = null;
    // gptResult = '';
    // name = '';
    // notifyListeners();
    return recordResult && remindResult && groupResult;
  }
  // Future<Map<String, dynamic>> uploadData(
  //   String userId,
  //   bool isExtra,
  //   int id,
  //   UserReport? report,
  // ) async {
  //   isSaving = true;
  //   notifyListeners();

  //   bool recordResult = await addRecord();
  //   bool remindResult = notify ? await addRemind(userId) : true;
  //   bool groupResult = true;
  //   Map<String, dynamic> resultMap = {};
  //   if (isExtra && report != null) {
  //     resultMap = await _addGroup(id, report);
  //     groupResult = resultMap['result'];
  //   }

  //   return {
  //     'result': recordResult && remindResult && groupResult,
  //     'newGroupId': resultMap['newGroupId'] ?? 0
  //   };
  // }

  UserReport toUserReport(int remindId) {
    reminds.clear();
    for (int i = 0; i < remindList.length; i++) {
      reminds.add(UserRemind(
          id: remindId + i,
          recordId: recordId,
          userId: userId,
          date: remindList[i]['day'],
          time: remindList[i]['time'],
          freq: remindFreq));
    }
    return UserReport(
        userId: userId,
        id: recordId,
        date: date,
        type: woundType,
        photo: imageUrl,
        oktime: oktime,
        caremode: gptResult,
        ifcall: notify ? 'Y' : 'N',
        choosekind: tags,
        recording: selfRecord,
        name: name,
        groupId: groupId,
        role: role,
        bruiseType: bruiseType,
        reminds: reminds);
  }

  /// 清空所有變數
  // void clearAll() {
  //   userId = 0;
  //   recordId = 0;
  //   date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   image = null;
  //   woundType = '';
  //   careSteps = {};
  //   gptResult = '';
  //   oktime = '';
  //   isLoading = true;
  //   notify = false;
  //   remindFreq = '每天';
  //   remindTime =
  //       "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
  //   hospitals = [];
  //   injuryParts = [];
  //   woundReactions = [];
  //   imageUrls = [];
  //   steps = [];
  //   open = false;
  //   selfRecord = '';
  //   updateButton = false;
  //   isUpdating = false;
  //   newOktime = '';
  //   isSaving = false;
  //   isSwitch = false;
  //   name = '';
  //   imageUrl = '';
  //   tags = '';
  //   groupId = 0;
  //   remindList = [];
  //   reminds = [];
  //   notifyListeners();
  // }

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
