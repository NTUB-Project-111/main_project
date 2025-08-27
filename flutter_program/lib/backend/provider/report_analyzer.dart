// // import 'package:flutter/foundation.dart';

// // class ReportAnalyzer with ChangeNotifier {
// //   bool _isLoading = false;
// //   bool get isLoading => _isLoading;
// //   set isLoading(bool value) {
// //     _isLoading = value;
// //     notifyListeners();
// //   }

// //   Map<String, dynamic> _data = {};
// //   Map<String, dynamic> get data => _data;

// //   String _result = "";
// //   String get result => _result;

// //   Future<void> loadData(
// //     String birthday,
// //     String disease,
// //     String freq,
// //     bool isExtra,
// //     String? oktime,
// //     String? date,
// //     String? woundType,
// //   ) async {
// //     isLoading = true;

// //     try {
// //       await Future.delayed(const Duration(seconds: 1)); // 模擬分析

// //       _data = {
// //         "birthday": birthday,
// //         "disease": disease,
// //         "freq": freq,
// //         "oktime": oktime,
// //         "date": date,
// //         "type": woundType,
// //         "extra": isExtra,
// //       };

// //       _result = "分析成功";
// //     } catch (e) {
// //       _result = "分析失敗: $e";
// //     } finally {
// //       isLoading = false;
// //     }
// //   }
// // }

// import 'package:flutter/material.dart';

// class ReportAnalyzer extends ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Map<String, dynamic>? _result;
//   Map<String, dynamic>? get result => _result;

//   void setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   Future<void> loadData({
//     required Future<Map<String, dynamic>> Function() asyncCallback,
//   }) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       _result = await asyncCallback();
//     } catch (e) {
//       debugPrint("分析失敗：$e");
//       _result = null; // 防呆
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

