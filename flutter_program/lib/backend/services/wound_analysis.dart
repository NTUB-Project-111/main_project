import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class WoundAnalysis {
  static Future<String> analyzeWound(File imageFile) async {
    // Map<String, String> woundMap = {
    //   'Abrasions': '擦傷',
    //   'Bruise': '瘀青',
    //   'Burn': '燒傷',
    //   'Cut': '割傷',
    //   '無異常': '無異常'
    // };
    Map<String, String> woundMap = {
      'slight_abrasion': '擦傷',
      'slight_bruise': '瘀青',
      'slight_burn': '燒傷',
      'slight_cut': '割傷',
      'slight_stab': '刺傷',
      'slight_surgical': '手術傷口',
      'serious': '嚴重',
      '無異常': '無異常'
    };

    try {
      final apiKey = dotenv.env['YOLO_API_KEY'];
      final String modelUrl =
          // "https://detect.roboflow.com/wound-ebsdw/10?api_key=$apiKey"; //模型v1
          // "https://detect.roboflow.com/wound-no-blister-2/1?api_key=$apiKey";  //模型v2
          "https://detect.roboflow.com/wound-grading/3?api_key=$apiKey"; //模型v3

      final bytes = await imageFile.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) throw Exception("無法解析圖片");
      final resized = img.copyResize(decoded, width: 640, height: 640);

      final tempDir = Directory.systemTemp;
      final tempFilePath = path.join(tempDir.path, "resized_img.jpg");
      final tempFile = File(tempFilePath);
      // await tempFile.writeAsBytes(img.encodeJpg(resized));
      await tempFile.writeAsBytes(img.encodeJpg(resized, quality: 100));

      var request = http.MultipartRequest('POST', Uri.parse(modelUrl));
      request.fields["confidence"] = "50";
      request.fields["overlap"] = "50";
      request.files
          // .add(await http.MultipartFile.fromPath("image", tempFilePath));
          .add(await http.MultipartFile.fromPath("file", tempFilePath));
      var response = await request.send();
      if (response.statusCode != 200) {
        print("API 請求失敗: ${response.statusCode}");
        print(await response.stream.bytesToString()); // ⭐ 印出錯誤內容
        throw Exception("API 請求失敗: ${response.statusCode}");
      }

      var responseData = await response.stream.bytesToString();
      var results = json.decode(responseData);

      Set<String> detectedWoundTypes = {};
      for (var obj in results["predictions"]) {
        if (obj["class"] != null) detectedWoundTypes.add(obj["class"]);
      }
      print("Status Code: ${response.statusCode}");
      print("Response Body: $responseData");

      final String woundType =
          detectedWoundTypes.isNotEmpty ? detectedWoundTypes.first : "無異常";

      return woundMap[woundType] ?? '無異常';
    } catch (e) {
      return "分析失敗";
    }
  }
}
