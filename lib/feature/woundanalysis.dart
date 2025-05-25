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

      return {"woundType": careSteps[0],"oktime":careSteps[1], "careSteps": careSteps.sublist(2)};
    } catch (e) {
      return {
        "woundType": "分析失敗",
        "careSteps": ["錯誤：$e"]
      };
    }
  }

  static List<String> _getCareInfo(String woundType) {
    final Map<String, List<String>> careInfo = {
      "Abrasions": ["擦傷","7~10", "用生理鹽水清洗傷口", "每天更換敷料，保持清潔", "避免摩擦傷口"],
      "Bruise": ["瘀青","7~14", "冰敷:於發生的72小時內冰敷，使局部血管收縮，減少血液流出造成組織腫脹","抹藥：若出血過多導致血腫可用藥來幫助緩解，若出現嚴重性血腫，使傷口越來越大，請一定要就醫", "熱敷:72小時後可給予熱敷按摩，以促進血液循環、代謝殘餘血塊"],
      "Burn": ["燒傷","8~30", "用冷水沖洗燙傷處", "避免使用冰塊", "保持傷口清潔，避免感染"],
      "Cut": ["割傷","7~10", "止血並清潔傷口", "使用繃帶包紮，保持乾燥"],
      "無異常": ["無異常","", "未檢測到異常傷口"],
    };
    return careInfo[woundType] ?? ["無異常","", "未檢測到異常傷口"];
  }
}
