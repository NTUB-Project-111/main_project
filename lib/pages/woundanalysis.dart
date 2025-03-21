import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class WoundAnalysis {
  static const String apiKey = "B0Imj5OwU9lbQC4ApdmC"; // API 金鑰

  static Future<Map<String, dynamic>> analyzeWound(File imageFile) async {

    try {
      const String modelUrl = "https://detect.roboflow.com/wound-ebsdw/10?api_key=$apiKey";

      final bytes = await imageFile.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) throw Exception("無法解析圖片");
      final resized = img.copyResize(decoded, width: 640, height: 640);

      final tempDir = Directory.systemTemp;
      final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(img.encodeJpg(resized));

      var request = http.MultipartRequest('POST', Uri.parse(modelUrl));
      request.fields["confidence"] = "50";
      request.fields["overlap"] = "50";
      request.files.add(await http.MultipartFile.fromPath("file", tempFilePath));

      var response = await request.send();
      if (response.statusCode != 200) throw Exception("API 請求失敗: ${response.statusCode}");

      var responseData = await response.stream.bytesToString();
      var results = json.decode(responseData);

      Set<String> detectedWoundTypes = {};
      for (var obj in results["predictions"]) {
        if (obj["class"] != null) detectedWoundTypes.add(obj["class"]);
      }

      final String woundType = detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異常";
      final List<String> careSteps = _getCareInfo(woundType);

      return {"woundType": careSteps[0], "careSteps": careSteps.sublist(1)};
    } catch (e) {
      return {
        "woundType": "分析失敗",
        "careSteps": ["錯誤：$e"]
      };
    }
  }

  static List<String> _getCareInfo(String woundType) {
    final Map<String, List<String>> careInfo = {
      "Abrasions": ["擦傷", "用生理鹽水清洗傷口", "每天更換敷料，保持清潔", "避免摩擦傷口"],
      "Bruise": ["瘀青", "初期冰敷，減少腫脹", "後續可熱敷，加速癒合"],
      "Burn": ["燒傷", "用冷水沖洗燙傷處", "避免使用冰塊", "保持傷口清潔，避免感染"],
      "Cut": ["割傷", "止血並清潔傷口", "使用繃帶包紮，保持乾燥"],
      "無異常": ["無異常", "未檢測到異常傷口"],
    };
    return careInfo[woundType] ?? ["無異常", "未檢測到異常傷口"];
  }
}

// import 'dart:io';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image/image.dart' as img;
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';

// class WoundAnalysis {
//   static const String apiKey = "B0Imj5OwU9lbQC4ApdmC";

//   static Future<Map<String, dynamic>> analyzeWound(File imageFile) async {
//     try {
//       const String modelUrl = "https://detect.roboflow.com/wound-ebsdw/10?api_key=$apiKey";

//       final bytes = await imageFile.readAsBytes();
//       final decoded = img.decodeImage(bytes);
//       if (decoded == null) throw Exception("⚠️ 無法解析圖片，請確保為 JPG/PNG 格式");

//       final resized = img.copyResize(decoded, width: 640, height: 640); // ✅ 更小解析度
//       final tempDir = await getApplicationSupportDirectory(); 

//       // ✅ 檢查可用空間
//       var freeSpace = await tempDir.stat();
//       if (freeSpace.size < 100 * 1024) { 
//         throw Exception("⚠️ 可用空間不足 (${freeSpace.size} bytes)，請清理存儲空間");
//       }

//       final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
//       final tempFile = File(tempFilePath);

//       await tempFile.writeAsBytes(img.encodeJpg(resized, quality: 30)); // ✅ 更低品質
//       if (!tempFile.existsSync()) throw Exception("⚠️ 檔案未成功建立: $tempFilePath");

//       var request = http.MultipartRequest('POST', Uri.parse(modelUrl));
//       request.fields["confidence"] = "50";
//       request.fields["overlap"] = "50";
//       request.files.add(await http.MultipartFile.fromPath("file", tempFilePath));

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();
//       print("🔍 API 回應: $responseData");

//       if (response.statusCode != 200) throw Exception("API 請求失敗: ${response.statusCode}");

//       var results = json.decode(responseData);

//       Set<String> detectedWoundTypes = {};
//       for (var obj in results["predictions"]) {
//         if (obj["class"] != null) detectedWoundTypes.add(obj["class"]);
//       }

//       final String woundType = detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異常";
//       final List<String> careSteps = _getCareInfo(woundType);

//       return {"woundType": careSteps[0], "careSteps": careSteps.sublist(1)};
//     } catch (e) {
//       print("❌ 錯誤：$e");
//       return {
//         "woundType": "分析失敗",
//         "careSteps": ["錯誤：$e"]
//       };
//     }
//   }

//   static List<String> _getCareInfo(String woundType) {
//     final Map<String, List<String>> careInfo = {
//       "Abrasions": ["擦傷", "用生理鹽水清洗傷口", "每天更換敷料，保持清潔", "避免摩擦傷口"],
//       "Bruise": ["瘀青", "初期冰敷，減少腫脹", "後續可熱敷，加速癒合"],
//       "Burn": ["燒傷", "用冷水沖洗燙傷處", "避免使用冰塊", "保持傷口清潔，避免感染"],
//       "Cut": ["割傷", "止血並清潔傷口", "使用繃帶包紮，保持乾燥"],
//       "無異常": ["無異常", "未檢測到異常傷口"],
//     };
//     return careInfo[woundType] ?? ["無異常", "未檢測到異常傷口"];
//   }
// }

// wound_analysis.dart
// import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class WoundAnalysis {
//   static String apiKey = "B0Imj5OwU9lbQC4ApdmC";
//   static String modelUrl = "https://detect.roboflow.com/wound-ebsdw/10?api_key=";

//   // 進行傷口分析
//   static Future<Map<String, dynamic>> analyzeWound(File imageFile) async {
//     try {
//       final bytes = await imageFile.readAsBytes();
//       final decoded = img.decodeImage(bytes);
//       if (decoded == null) throw Exception("⚠️ 無法解析圖片，請確保為 JPG/PNG 格式");

//       final resized = img.copyResize(decoded, width: 640, height: 640); // 更小解析度
//       final tempDir = await getApplicationSupportDirectory();

//       final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
//       final tempFile = File(tempFilePath);

//       await tempFile.writeAsBytes(img.encodeJpg(resized, quality: 30)); // 更低品質

//       var request = http.MultipartRequest('POST', Uri.parse(modelUrl + apiKey));
//       request.fields["confidence"] = "50";
//       request.fields["overlap"] = "50";
//       request.files.add(await http.MultipartFile.fromPath("file", tempFilePath));

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();

//       if (response.statusCode != 200) throw Exception("API 請求失敗: ${response.statusCode}");

//       var results = json.decode(responseData);
//       Set<String> detectedWoundTypes = {};
//       for (var obj in results["predictions"]) {
//         if (obj["class"] != null) detectedWoundTypes.add(obj["class"]);
//       }

//       final String woundTypeResult = detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異常";
//       final List<String> careStepsResult = _getCareInfo(woundTypeResult);

//       return {
//         'woundType': careStepsResult[0],
//         'careSteps': careStepsResult.sublist(1),
//       };
//     } catch (e) {
//       return {
//         'woundType': "分析失敗",
//         'careSteps': ["錯誤：$e"],
//       };
//     }
//   }

//   // 根據傷口類型返回護理步驟
//   static List<String> _getCareInfo(String woundType) {
//     final Map<String, List<String>> careInfo = {
//       "Abrasions": ["擦傷", "用生理鹽水清洗傷口", "每天更換敷料，保持清潔", "避免摩擦傷口"],
//       "Bruise": ["瘀青", "初期冰敷，減少腫脹", "後續可熱敷，加速癒合"],
//       "Burn": ["燒傷", "用冷水沖洗燙傷處", "避免使用冰塊", "保持傷口清潔，避免感染"],
//       "Cut": ["割傷", "止血並清潔傷口", "使用繃帶包紮，保持乾燥"],
//       "無異常": ["無異常", "未檢測到異常傷口"],
//     };
//     return careInfo[woundType] ?? ["無異常", "未檢測到異常傷口"];
//   }
// }
