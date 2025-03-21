// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:path/path.dart' as path;
// // import 'package:image/image.dart' as img;
// // import './resultpages/result_1.dart';
// // import './resultpages/result_2.dart';
// // import './resultpages/result_3.dart';
// // import './resultpages/result_4.dart';
// // import './resultpages/result_5.dart';
// // import './headers/header_3.dart';

// // class WoundAnalysisPage extends StatefulWidget {
// //   final File image; // 傳入的圖片
// //   const WoundAnalysisPage({Key? key, required this.image}) : super(key: key);

// //   @override
// //   _WoundAnalysisPageState createState() => _WoundAnalysisPageState();
// // }

// // class _WoundAnalysisPageState extends State<WoundAnalysisPage> {
// //   List<String> _resultText = [];
// //   String _woundType = "";

// //   // 各傷口類型對應的護理資訊
// //   final Map<String, List<String>> _careinfo = {
// //     "Abrasions": [ //擦傷
// //       "請先用乾淨的冷開水或生理鹽水沖洗傷口，避免使用含酒精的產品，以免刺激傷口",
// //       "用乾淨的消毒紗布輕輕按壓傷口約5-10分鐘，直到止血",
// //       "使用抗菌藥膏輕輕塗抹於傷口表面，預防感染",
// //       "每天更換敷料一次，保持傷口乾燥和清潔",
// //       "注意避免讓傷口長時間潮濕，如流汗或接觸水",
// //       "如果出現嚴重疼痛或感染跡象，立即就醫"
// //     ],
// //     "Bruise": ["初期建議冰敷，幫助傷處組織收縮，也有助血液凝固，避免瘀血範圍擴大", "待紅腫熱痛症狀消退後，可改熱敷，以加速患部的血液代謝，助於瘀血消散"], //瘀傷
// //     "燒傷": [
// //       "移除熱源：確保遠離燙傷的熱源，避免進一步受傷",
// //       "沖洗傷口：用冷水（約15°C）沖洗燙傷部位10-30分鐘，以降低皮膚溫度並減少損傷範圍，避免使用冰塊",
// //       "清潔傷口：用生理食鹽水或清水輕輕清洗傷口",
// //       "覆蓋傷口：輕輕拍乾後，用無菌紗布或乾淨的布料覆蓋傷口，保持清潔，避免感染",
// //       "使用燒傷專用藥膏：促進傷口癒合",
// //       "注意觀察：若出現感染跡象（紅腫、發熱、流膿），應立即就醫",
// //       "避免使用刺激性消毒劑：如酒精等，避免傷口受到二次刺激"
// //     ],
// //     "Cut": ["止血：在傷口處放一塊乾淨且能吸水的布，以手壓緊直到傷口止血", "傷口清潔：用乾淨的開水或生理食鹽水輕輕洗淨傷口", "傷口覆蓋：使用繃帶或紗布覆蓋傷口，並保持乾燥"],
// //     "no abnormalit": ["無異狀"]
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _analyzeImage(widget.image); // 使用傳入的圖片進行分析
// //   }

// //   // 透過 Ultralytics API 分析傷口種類
// //   Future<void> _analyzeImage(File imageFile) async {
// //     try {
// //       // API 設置
// //       final String url = "https://predict.ultralytics.com";
// //       // 請將下方的 API 金鑰換成你實際的金鑰
// //       final String apiKey = "b8503b3325060f16707d53f0aecb56d932ab5ca06d";
// //       final Map<String, String> headers = {"x-api-key": apiKey};
// //       final Map<String, String> fields = {
// //         "model": "https://hub.ultralytics.com/models/AJ6ZNdobu3ogKz9Xcybz",
// //         "imgsz": "640",
// //         "conf": "0.5",
// //         "iou": "0.5",
// //       };

// //       // 讀取並調整圖片大小至 640x640
// //       final bytes = await imageFile.readAsBytes();
// //       final decoded = img.decodeImage(bytes);
// //       if (decoded == null) {
// //         throw Exception("無法解析圖片");
// //       }
// //       final resized = img.copyResize(decoded, width: 640, height: 640);

// //       // 將調整大小後的圖片存成暫存檔案
// //       final tempDir = Directory.systemTemp;
// //       final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
// //       final tempFile = File(tempFilePath);
// //       await tempFile.writeAsBytes(img.encodeJpg(resized));
// //       print("上傳圖片: $tempFilePath");

// //       // 建立 multipart request
// //       var request = http.MultipartRequest('POST', Uri.parse(url));
// //       request.headers.addAll(headers);
// //       request.fields.addAll(fields);
// //       request.files.add(await http.MultipartFile.fromPath("file", tempFilePath));

// //       // 發送請求並取得回應
// //       var response = await request.send();
// //       if (response.statusCode != 200) {
// //         throw Exception("API 請求失敗，狀態碼: ${response.statusCode}");
// //       }
// //       var responseData = await response.stream.bytesToString();
// //       var results = json.decode(responseData);
// //       // print(json.encode(results)); //印出 API 回傳內容

// //       // 從 API 回傳中擷取偵測到的傷口類型
// //       Set<String> detectedWoundTypes = {};
// //       for (var obj in results["images"][0]["results"]) {
// //         if (obj["name"] != null) {
// //           detectedWoundTypes.add(obj["name"]);
// //         }
// //       }
// //       // 若有多種傷口類型，這裡採用第一個作為分析結果
// //       final String woundType = detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異狀";
// //       print(woundType);
// //       setState(() {
// //         _woundType = woundType;
// //         _resultText = _careinfo[woundType] ?? ["未提供護理資訊"];
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _resultText = ["分析失敗：$e"];
// //       });
// //       print("錯誤：$e");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFEBFEFF),
// //       body: Column(
// //         children: [
// //           const HeaderPage3(), // 固定標頭
// //           const ResultPage1(), // 固定結果頁面 1
// //           Expanded(
// //             child: SingleChildScrollView(
// //               child: Padding(
// //                 padding: const EdgeInsets.fromLTRB(14, 0, 14, 89),
// //                 child: Column(
// //                   children: [
// //                     ResultPage2(woundType: _woundType, image: widget.image),
// //                     ResultPage3(resultinfo: _resultText),
// //                     const ResultPage4(),
// //                     const ResultPage5(),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:path/path.dart' as path;
// // import 'package:image/image.dart' as img;
// // import './resultpages/result_1.dart';
// // import './resultpages/result_2.dart';
// // import './resultpages/result_3.dart';
// // import './resultpages/result_4.dart';
// // import './resultpages/result_5.dart';
// // import './resultpages/result_6.dart';
// // import './headers/header_3.dart';

// // class WoundAnalysisPage extends StatefulWidget {
// //   final File image; // 傳入的圖片
// //   const WoundAnalysisPage({Key? key, required this.image}) : super(key: key);

// //   @override
// //   _WoundAnalysisPageState createState() => _WoundAnalysisPageState();
// // }

// // class _WoundAnalysisPageState extends State<WoundAnalysisPage> {
// //   List<String> _resultText = [];
// //   String _woundType = "";

// //   @override
// //   void initState() {
// //     super.initState();
// //     _analyzeImage(widget.image); // 使用傳入的圖片進行分析
// //   }

// //   // 使用 Roboflow API 進行分析
// //   Future<void> _analyzeImage(File imageFile) async {
// //     try {
// //       const String apiKey = "B0Imj5OwU9lbQC4ApdmC"; // 直接寫入 API 金鑰
// //       if (apiKey.isEmpty) throw Exception("API 金鑰未設定");
      
// //       // final String modelUrl = "https://detect.roboflow.com/wound-ebsdw/10";

      
// //       const String modelUrl = "https://detect.roboflow.com/wound-ebsdw/10?api_key=$apiKey";

// //       // final Map<String, String> headers = {"Authorization": "Bearer $apiKey"};
      
// //       // 讀取並調整圖片大小至 640x640
// //       final bytes = await imageFile.readAsBytes();
// //       final decoded = img.decodeImage(bytes);
// //       if (decoded == null) throw Exception("無法解析圖片");
// //       final resized = img.copyResize(decoded, width: 640, height: 640);
      
// //       // 暫存調整後的圖片
// //       final tempDir = Directory.systemTemp;
// //       final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
// //       final tempFile = File(tempFilePath);
// //       await tempFile.writeAsBytes(img.encodeJpg(resized));

// //       // 建立 multipart request
// //       var request = http.MultipartRequest('POST', Uri.parse(modelUrl));


// //       // request.headers.addAll(headers);


// //       request.fields["confidence"] = "50";
// //       request.fields["overlap"] = "50";
// //       request.files.add(await http.MultipartFile.fromPath("file", tempFilePath));
      
// //       var response = await request.send();
// //       if (response.statusCode != 200) throw Exception("API 請求失敗: ${response.statusCode}");
      
// //       var responseData = await response.stream.bytesToString();
// //       var results = json.decode(responseData);
      
// //       Set<String> detectedWoundTypes = {};
// //       for (var obj in results["predictions"]) {
// //         if (obj["class"] != null) detectedWoundTypes.add(obj["class"]);
// //       }
      
// //       final String woundType = detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異狀";
      
// //       setState(() {
// //         _woundType = woundType;
// //         _resultText = _getCareInfo(woundType);
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _resultText = ["分析失敗：$e"];
// //       });
// //       print("錯誤：$e");
// //     }
// //   }

// //   List<String> _getCareInfo(String woundType) {
// //     final Map<String, List<String>> careInfo = {
// //       "Abrasions": [
// //         "擦傷",
// //         "用生理鹽水清洗傷口",
// //         "每天更換敷料，保持清潔",
// //         "避免摩擦傷口",
// //       ],
// //       "Bruise": [
// //         "瘀青",
// //         "初期冰敷，減少腫脹",
// //         "後續可熱敷，加速癒合",
// //       ],
// //       "Burn": [
// //         "燒傷",
// //         "用冷水沖洗燙傷處",
// //         "避免使用冰塊",
// //         "保持傷口清潔，避免感染",
// //       ],
// //       "Cut": [
// //         "割傷",
// //         "止血並清潔傷口",
// //         "使用繃帶包紮，保持乾燥",
// //       ],
// //       "無異常": ["無異常","未檢測到異常傷口"],
// //     };
// //     return careInfo[woundType] ?? ["無異常","未檢測到異常傷口"];
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFEBFEFF),
// //       body: Column(
// //         children: [
// //           const HeaderPage3(),
// //           const ResultPage1(),
// //           Expanded(
// //             child: SingleChildScrollView(
// //               child: Padding(
// //                 padding: const EdgeInsets.fromLTRB(14, 0, 14, 89),
// //                 child: Column(
// //                   children: [
// //                     ResultPage2(woundType: _resultText[0], image: widget.image),
// //                     ResultPage3(resultinfo: _resultText.sublist(1)),//取索引0以後的所有元素
// //                     _resultText[0] != "無異常" ? const ResultPage4() : const SizedBox(),
// //                     _resultText[0] != "無異常" ? const ResultPage5() : const SizedBox(),
// //                     ResultPage6(woundType: _resultText[0]),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:image/image.dart' as img;
// import './resultpages/result_1.dart';
// import './resultpages/result_2.dart';
// import './resultpages/result_3.dart';
// import './resultpages/result_4.dart';
// import './resultpages/result_5.dart';
// import './resultpages/result_6.dart';
// import './headers/header_3.dart';
// // import 'package:location/location.dart';

// // const String googleMapsApiKey = "AIzaSyCDjOjWfvAM9JpXwMRdJVhKL77lCOfvezs";

// class WoundAnalysisPage extends StatefulWidget {
//   final File image; // 傳入的圖片
//   const WoundAnalysisPage({super.key, required this.image});

//   @override
//   _WoundAnalysisPageState createState() => _WoundAnalysisPageState();
// }

// class _WoundAnalysisPageState extends State<WoundAnalysisPage> {
//   List<String> _resultText = [];
//   String _woundType = "";
//   bool _isLoading = true; // 加載狀態

//   @override
//   void initState() {
//     super.initState();
//     _analyzeImage(widget.image);
//   }

//   // 使用 Roboflow API 進行分析
//   Future<void> _analyzeImage(File imageFile) async {
//     try {
//       const String apiKey = "B0Imj5OwU9lbQC4ApdmC"; // API 金鑰
//       if (apiKey.isEmpty) throw Exception("API 金鑰未設定");

//       const String modelUrl = "https://detect.roboflow.com/wound-ebsdw/10?api_key=$apiKey";

//       final bytes = await imageFile.readAsBytes();
//       final decoded = img.decodeImage(bytes);
//       if (decoded == null) throw Exception("無法解析圖片");
//       final resized = img.copyResize(decoded, width: 640, height: 640);

//       final tempDir = Directory.systemTemp;
//       final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
//       final tempFile = File(tempFilePath);
//       await tempFile.writeAsBytes(img.encodeJpg(resized));

//       var request = http.MultipartRequest('POST', Uri.parse(modelUrl));
//       request.fields["confidence"] = "50";
//       request.fields["overlap"] = "50";
//       request.files.add(await http.MultipartFile.fromPath("file", tempFilePath));

//       var response = await request.send();
//       if (response.statusCode != 200) throw Exception("API 請求失敗: ${response.statusCode}");

//       var responseData = await response.stream.bytesToString();
//       var results = json.decode(responseData);

//       Set<String> detectedWoundTypes = {};
//       for (var obj in results["predictions"]) {
//         if (obj["class"] != null) detectedWoundTypes.add(obj["class"]);
//       }

//       final String woundType = detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異狀";

//       setState(() {
//         _woundType = woundType;
//         _resultText = _getCareInfo(woundType);
//         _isLoading = false; // 加載完成
//       });
//     } catch (e) {
//       setState(() {
//         _resultText = ["分析失敗：$e"];
//         _isLoading = false; // 加載失敗後仍需關閉 loading
//       });
//       print("錯誤：$e");
//     }
//   }

//   List<String> _getCareInfo(String woundType) {
//     final Map<String, List<String>> careInfo = {
//       "Abrasions": ["擦傷", "用生理鹽水清洗傷口", "每天更換敷料，保持清潔", "避免摩擦傷口"],
//       "Bruise": ["瘀青", "初期冰敷，減少腫脹", "後續可熱敷，加速癒合"],
//       "Burn": ["燒傷", "用冷水沖洗燙傷處", "避免使用冰塊", "保持傷口清潔，避免感染"],
//       "Cut": ["割傷", "止血並清潔傷口", "使用繃帶包紮，保持乾燥"],
//       "無異常": ["無異常", "未檢測到異常傷口"],
//     };
//     return careInfo[woundType] ?? ["無異常", "未檢測到異常傷口"];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEBFEFF),
//       body: Column(
//         children: [
//           const HeaderPage3(),
//           // 加載中顯示 `LinearProgressIndicator`
//           if (_isLoading) const LinearProgressIndicator(minHeight: 5),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 0, 14, 89),
//                 child: Column(
//                   children: [
//                     if (!_isLoading) ...[
//                       const ResultPage1(),
//                       ResultPage2(woundType: _resultText[0], image: widget.image),
//                       ResultPage3(resultinfo: _resultText.sublist(1)), // 取索引 0 以後的所有元素
//                       // if (_resultText[0] != "無異常") const ResultPage4(),
//                       if (_resultText[0] != "無異常") const ResultPage5(),
//                       ResultPage6(woundType: _resultText[0]),
//                     ]
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
