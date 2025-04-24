import 'package:flutter/material.dart';
import 'package:wounddetection/feature/database.dart';
import '../feature/hospitallist.dart';
import '../feature/woundanalysis.dart';
import 'dart:io';
import './resultpages/result_1.dart';
import './resultpages/result_2.dart';
import './resultpages/result_3.dart';
import './resultpages/result_4.dart';
import './resultpages/result_5.dart';
import './resultpages/result_6.dart';
import './headers/header_3.dart';
import 'package:intl/intl.dart'; // 用於格式化日期

class ResultPage extends StatefulWidget {
  final File image;
  const ResultPage({super.key, required this.image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> _hospitals = [
    {"name": "A醫院", "distanceText": "1公里", "durationText": "10分鐘", "address": "xxx"}
  ]; // 存放醫院資料
  String _woundType = "未分析"; // 傷口類型
  String _oktime = "";
  List<String> _careSteps = []; // 護理資訊
  bool _isLoading = true; // 控制畫面顯示 loading 狀態
  late String formattedDate;
  String _newoktime = "";
  @override
  void initState() {
    super.initState();
    _loadData(); //加載資料
    formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DatabaseHelper.record['date'] = formattedDate;
    DatabaseHelper.record['freq'] = "每天";
    DatabaseHelper.record['ifcall'] = 'N';
    DatabaseHelper.record['choosekind'] = "";
    DatabaseHelper.record['recording'] = "";
    DatabaseHelper.record['part'] = "";
    DatabaseHelper.record['rection'] = "";
  }

  /// 同時加載醫院資料和傷口分析結果
  Future<void> _loadData() async {
    try {
      // await Future.wait([_fetchHospitals(), _analyzeWoundImage()]);
      await Future.wait([_analyzeWoundImage()]);
    } finally {
      setState(() {
        _isLoading = false; // 資料加載完成，更新狀態
      });
    }
  }

  // 測試醫院 API 回傳資料
  // Future<void> _fetchHospitals() async {
  //   List<Map<String, dynamic>> hospitals = await HospitalSearch.getNearbyHospitals();
  //   setState(() {
  //     _hospitals = hospitals;
  //     // print(_hospitals);
  //   });
  // }

  // / 測試 Image.asset('images/1.png') 並分析傷口
  Future<void> _analyzeWoundImage() async {
    try {
      final File imageFile = widget.image;
      final result = await WoundAnalysis.analyzeWound(imageFile);

      setState(() {
        _woundType = result["woundType"];
        _careSteps = result["careSteps"];
        _oktime = result["oktime"];
        DatabaseHelper.record['type'] = _woundType;
        DatabaseHelper.record['caremode'] = _careSteps;
        DatabaseHelper.record['image'] = imageFile;
        DatabaseHelper.record['oktime'] = _oktime;
      });
    } catch (e) {
      setState(() {
        _woundType = "分析失敗";
        _careSteps = ["錯誤: $e"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBFEFF),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // 資料加載中顯示 loading 圖示
          : Column(
              children: [
                const HeaderPage3(),
                ResultPage1(date: formattedDate),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 89),
                      child: Column(
                        children: [
                          ResultPage2(
                            woundType: _woundType,
                            image: widget.image,
                            oktime: Text(
                              (_newoktime.isNotEmpty ? _newoktime : _oktime),
                              style: TextStyle(
                                color: _newoktime != "" ? Colors.red : const Color(0xFF589399),
                                fontSize: 26,
                              ),
                            ),
                          ),
                          ResultPage3(
                            resultinfo: _careSteps,
                          ),
                          // if (_woundType != "無異常") ResultPage4(hospitals: _hospitals),
                          if (_woundType != "無異常")
                            ResultPage5(
                              onDataChanged: (data) {
                                setState(() {
                                  _newoktime = "";
                                  _newoktime = data;
                                });
                              },
                              woundtype: _woundType,
                            ),
                          ResultPage6(
                            woundType: _woundType,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
