// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:image/image.dart' as img;
// import 'package:path/path.dart' as path;
// import 'package:flutter/material.dart';

// class WoundAnalysis {
//   static Future<String> analyzeWound(File imageFile) async {
//     // Map<String, String> woundMap = {
//     //   'Abrasions': '擦傷',
//     //   'Bruise': '瘀青',
//     //   'Burn': '燒傷',
//     //   'Cut': '割傷',
//     //   '無異常': '無異常'
//     // };
//     Map<String, String> woundMap = {
//       'slight_abrasion': '擦傷',
//       'slight_bruise': '瘀青',
//       'slight_burn': '燒傷',
//       'slight_cut': '割傷',
//       'slight_stab': '刺傷',
//       'slight_surgical': '手術傷口',
//       'serious': '嚴重傷口',
//       '無異常': '無異常'
//     };

//     try {
//       final apiKey = dotenv.env['YOLO_API_KEY'];
//       final String modelUrl =
//           // "https://detect.roboflow.com/wound-ebsdw/10?api_key=$apiKey"; //模型v1
//           // "https://detect.roboflow.com/wound-no-blister-2/1?api_key=$apiKey";  //模型v2
//           "https://detect.roboflow.com/wound-grading/3?api_key=$apiKey"; //模型v3

//       final bytes = await imageFile.readAsBytes();
//       final decoded = img.decodeImage(bytes);
//       if (decoded == null) throw Exception("無法解析圖片");
//       final resized = img.copyResize(decoded, width: 640, height: 640);

//       final tempDir = Directory.systemTemp;
//       final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
//       final tempFile = File(tempFilePath);
//       // await tempFile.writeAsBytes(img.encodeJpg(resized));
//       await tempFile.writeAsBytes(img.encodeJpg(resized, quality: 100));

//       var request = http.MultipartRequest('POST', Uri.parse(modelUrl));
//       request.fields["confidence"] = "50";
//       request.fields["overlap"] = "50";
//       request.files
//           // .add(await http.MultipartFile.fromPath("image", tempFilePath));
//           .add(await http.MultipartFile.fromPath("file", tempFilePath));
//       var response = await request.send();
//       if (response.statusCode != 200) {
//         debugPrint("API 請求失敗: ${response.statusCode}");
//         print(await response.stream.bytesToString()); // 印出錯誤內容
//         throw Exception("API 請求失敗: ${response.statusCode}");
//       }

//       var responseData = await response.stream.bytesToString();
//       var results = json.decode(responseData);

//       Set<String> detectedWoundTypes = {};
//       for (var obj in results["predictions"]) {
//         if (obj["class"] != null) detectedWoundTypes.add(obj["class"]);
//       }
//       print("Status Code: ${response.statusCode}");
//       print("Response Body: $responseData");

//       final String woundType =
//           detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異常";

//       return woundMap[woundType] ?? '無異常';
//     } catch (e) {
//       return "分析失敗";
//     }
//   }
// }

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 用來讀取環境變數 (.env) 的套件
import 'package:http/http.dart' as http; // 發送 HTTP 請求用
import 'package:image/image.dart' as img; // 圖片處理套件
import 'package:path/path.dart' as path; // 路徑處理套件

class WoundAnalysis {
  // 定義一個靜態方法，用來分析傷口影像，回傳分析結果字串
  static Future<String> analyzeWound(File imageFile) async {
    // 建立英文類別名稱 → 中文描述的對應表
    Map<String, String> woundMap = {
      'slight_abrasion': '擦傷',
      'slight_bruise': '瘀青',
      'slight_burn': '燒燙傷',
      'slight_cut': '割傷',
      'slight_stab': '刺傷',
      'slight_surgical': '手術傷口',
      'serious': '嚴重傷口',
      '無異常': '無異常'
    };

    try {
      // 從 .env 讀取 YOLO 模型的 API 金鑰
      final apiKey = dotenv.env['YOLO_API_KEY'];

      // 設定 API 模型 URL
      final String modelUrl =
          // "https://detect.roboflow.com/wound-ebsdw/10?api_key=$apiKey"; // 模型 v1
          // "https://detect.roboflow.com/wound-no-blister-2/1?api_key=$apiKey"; // 模型 v2
          "https://detect.roboflow.com/wound-grading/3?api_key=$apiKey"; // 模型 v3

      // 讀取圖片的 byte 資料
      final bytes = await imageFile.readAsBytes();

      // 解碼圖片為可操作的物件
      final decoded = img.decodeImage(bytes);
      if (decoded == null) throw Exception("無法解析圖片");

      // 將圖片縮放到 YOLO 模型需求的大小 (640x640)
      final resized = img.copyResize(decoded, width: 640, height: 640);

      // 建立暫存檔案，將縮放後的圖片存成 jpg
      final tempDir = Directory.systemTemp;
      final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(img.encodeJpg(resized, quality: 100));

      // 建立 HTTP 請求，使用 Multipart 傳送圖片
      var request = http.MultipartRequest('POST', Uri.parse(modelUrl));
      request.fields["confidence"] = "50"; // 設定信心門檻值
      request.fields["overlap"] = "50"; // 設定重疊比例
      request.files.add(await http.MultipartFile.fromPath("file", tempFilePath));

      // 發送請求
      var response = await request.send();

      // 如果 API 回傳非 200，代表失敗
      if (response.statusCode != 200) {
        debugPrint("API 請求失敗: ${response.statusCode}");
        debugPrint(await response.stream.bytesToString()); // 印出錯誤內容方便除錯
        throw Exception("API 請求失敗: ${response.statusCode}");
      }

      // 讀取回應內容
      var responseData = await response.stream.bytesToString();
      var results = json.decode(responseData);

      // 建立集合，用來儲存辨識到的傷口種類
      Set<String> detectedWoundTypes = {};
      if (results["predictions"] is List) {
        for (var obj in results["predictions"]) {
          if (obj is Map && obj["class"] != null) {
            detectedWoundTypes.add(obj["class"]);
          }
        }
      }

      // 除錯輸出 API 回傳狀態與內容
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: $responseData");
      debugPrint("Predictions: ${jsonEncode(results["predictions"])}");

      // // 如果有辨識到傷口，就取第一個結果；否則回傳「無異常」
      // final String woundType = detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異常";
      // 回傳信心值最高的傷口種類
      String woundType = "無異常";
      if (results["predictions"] is List && results["predictions"].isNotEmpty) {
        // 依 confidence 由大到小排序
        var sorted = List<Map<String, dynamic>>.from(results["predictions"]);
        sorted.sort((a, b) => (b["confidence"] as num).compareTo(a["confidence"] as num));

        // 取信心值最高的那一筆
        var best = sorted.first;
        if (best["class"] is String) {
          woundType = best["class"];
        }
      }

      // 將英文類別轉成對應的中文描述
      return woundMap[woundType] ?? '無異常';
    } catch (e, s) {
      // 如果中途發生錯誤，回傳「分析失敗」
      debugPrint("分析失敗原因: $e");
      debugPrint("Stack: $s");
      return "分析失敗";
    }
  }
}
