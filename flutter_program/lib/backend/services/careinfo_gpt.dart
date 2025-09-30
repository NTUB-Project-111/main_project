import 'dart:convert';
import 'package:drw/backend/services/caresteps_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CareInfo {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static var apiKey = dotenv.env['OPEN_AI_API_KEY'];

  static Future<String> getOktime(String woundType, String part, String rection, String description,
      String birthday, String disease, String freq) async {
    int year = DateTime.now().year;
    int age = year - int.parse(birthday);
    String diseases = disease.replaceAll('[', '').replaceAll(']', '');
    List<String> freqs = freq.split('、');
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {
              "role": "system",
              "content": '''你是一位專業的外科醫生，根據患者的描述，及提供的傷口類型、受傷部位、
                  傷口狀態與其他描述，預測其大約癒合時間並回答，只須回答癒合時間並以天數為單位，
                  不需要回答其他文字敘述，例如:4~10天、7天、5~7天'''
            },
            {
              "role": "user",
              "content": '''
                我的年齡為$age歲，
                疾病:$diseases，
                習慣:${freqs[0]}抽菸、${freqs[1]}喝酒、${freqs[2]}嚼檳榔，
                我有一個$woundType，
                受傷部位: $part,
                傷口狀態: $rection,
                其他描述: $description,
                請幫我估算癒合時間。'''
            }
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // 避免亂碼
        final Map<String, dynamic> data = jsonDecode(decodedBody);
        return data["choices"][0]["message"]["content"];
      } else {
        return "分析失敗，請稍後再試";
      }
    } catch (e) {
      return "請求失敗，請檢查網路連線";
    }
  }

  static Future<Map<String, dynamic>?> getCareSteps(
    String woundType,
    String birthday,
    String disease,
    String freq,
    bool isExtra,
    String? date,
  ) async {
    try {
      // 計算年齡
      int age = 0;
      if (birthday != '') {
        int year = DateTime.now().year;
        age = year - int.parse(birthday);
      }

      // 處理疾病與習慣字串
      String diseases = disease.replaceAll('[', '').replaceAll(']', '');
      final freqs = freq.split('、');
      final smoke = freqs.isNotEmpty ? freqs[0] : '沒有';
      final drink = freqs.length > 1 ? freqs[1] : '沒有';
      final betel = freqs.length > 2 ? freqs[2] : '沒有';

      //計算受傷距今天數
      DateTime today = DateTime.now();
      int? days;
      if (date != null) {
        DateTime injuryDate = DateTime.parse(date);
        days = today.difference(injuryDate).inDays;
      }

      // 對應參考資料
      String referenceText = '';
      if (isExtra) {
        switch (woundType) {
          case '燒傷':
          case '燙傷':
            referenceText = CareStepsReference.burnCare;
            break;
          case '瘀青':
            referenceText = CareStepsReference.bruise;
            break;
          case '手術傷口':
            referenceText = CareStepsReference.surgical;
            break;
          case '擦傷':
          case '割傷':
          case '刺傷':
            referenceText = CareStepsReference.woundCare;
            break;
          default:
            referenceText = '';
        }
      } else {
        switch (woundType) {
          case '燒傷':
          case '燙傷':
            referenceText = '燒燙傷:\n${CareStepsReference.burn}';
            break;
          case '瘀青':
            referenceText = '瘀青:\n${CareStepsReference.bruise}';
            break;
          case '手術傷口':
            referenceText = '手術傷口:\n${CareStepsReference.surgical}';
            break;
          case '擦傷':
            referenceText = '擦傷:\n${CareStepsReference.abrasion}';
            break;
          case '割傷':
            referenceText = '割傷:\n${CareStepsReference.cut}';
            break;
          case '刺傷':
            referenceText = '刺傷:\n${CareStepsReference.stab}';
            break;
          default:
            referenceText = '';
        }
      }

      String userMessageContent = isExtra
          ? '''
          傷口類型: $woundType，
          描述: 
            我的年齡為$age歲，
            我有$diseases，
            並且$smoke抽菸、$drink喝酒、$betel嚼檳榔，
            距離上次受傷已經過${days ?? '未知'}天，
          請提供傷口的護理建議，不需要估算癒合時間。
          請參考網站內容作為依據：
            $referenceText
          '''
          : birthday != ''
              ? '''
          傷口類型: $woundType，
          描述: 
            我的年齡為$age歲，
            我有$diseases，
            並且$smoke抽菸、$drink喝酒、$betel嚼檳榔，
          請提供傷口的護理建議及預估癒合時間。
          請參考以下網站內容作為依據：
          $referenceText
          '''
              : '''
          傷口類型: $woundType，
          描述: 
          請提供傷口的護理建議及預估癒合時間。
          請參考以下網站內容作為依據：
          $referenceText
          ''';

      debugPrint(userMessageContent);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {
              "role": "system",
              "content": """
              你是一位專業外科醫生。根據使用者提供的傷口資訊，請依照以下規則回覆護理建議：

              1. 每個步驟格式：
                標題: 
                  多行縮排說明，每行以句號結尾。
                  最後一句必須以分號結尾。
              2. 最後一行必須提供「癒合時間:N~M天」。
              3. 禁止任何前言、引言、結論。
              4. 如果只回覆癒合時間而沒有步驟，則回答視為錯誤，請重新生成。

              範例：
              止血:
                用繃帶或乾淨的布按壓傷口 10 分鐘。
                確保保持持續壓力;
              清潔傷口:
                徹底洗手並戴手套。
                使用乾淨的水清洗傷口。
                避免將肥皂直接進入傷口;
              包紮傷口:
                使用無菌敷料覆蓋傷口。
                若有滲血可再加一層繃帶;
              癒合時間:7~14天
              """
            },
            {"role": "user", "content": userMessageContent}
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(decodedBody);

        debugPrint("回傳資料: $data");

        final content = data["choices"][0]["message"]["content"];
        if (content is! String) {
          debugPrint("content 不是 String，而是 ${content.runtimeType}");
          return null;
        }

        String str = content;
        List<String> result = str.split('癒合時間:');
        List<String> steps = result[0].split(';');
        Map<String, List<String>> careSteps = {};

        for (var step in steps) {
          if (step.trim().isEmpty) continue;
          List<String> parts = step.split(':');
          if (parts.length < 2) continue;
          String title = parts[0].trim();
          String contentText = parts[1].trim();
          List<String> lines = contentText.split('。').where((s) => s.trim().isNotEmpty).toList();
          careSteps[title] = lines;
        }

        return {
          'careSteps': careSteps,
          'healingTime': result.length > 1 ? result[1].trim() : '',
          'gptResult': result[0].trim(),
        };
      } else {
        debugPrint("API 回傳非 200：${response.statusCode}");
        debugPrint(response.body);
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('發生例外: $e');
      debugPrint(stackTrace.toString());
      return null;
    }
  }
}
