import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CareInfo {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static var apiKey = dotenv.env['OPEN_AI_API_KEY'];

  static Future<String> getOktime(
      String woundType, String part, String rection, String description) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {
              "role": "system",
              "content":
                  "你是一位專業的醫療助理，根據傷口類型與描述，預測其大約癒合時間並回答，只須回答癒合時間並以天數為單位，不需要回答其他文字敘述，例如:4~10、7、5~7"
            },
            {"role": "user", "content": "傷口類型: $woundType$part$rection，描述: $description，請幫我估算癒合時間。"}
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

  static Future<Map<String, String>?> getCareSteps(
      String woundType, String birthday, String disease, String freq) async {
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
          "model": "gpt-4",
          "messages": [
            {
              "role": "system",
              "content": '''你是一位專業的外科醫生，根據傷口類型與描述，提供簡單明瞭的傷口處理步驟，並預測其大約的癒合時間。
                注意回答癒合時間需以天數為單位，不需要回答其他文字敘述，以下是回答的範例，但要注意這只是參考，並不是要回答的一模一樣：
                傷口類型:瘀青
                護理步驟:
                  冰敷:於發生的72小時內冰敷，使局部血管收縮，減少血液流出造成組織腫脹,
                  抹藥：若出血過多導致血腫可用藥來幫助緩解，若出現嚴重性血腫，使傷口越來越大，請一定要就醫,
                  熱敷:72小時後可給予熱敷按摩，以促進血液循環、代謝殘餘血塊
                     
                癒合時間:
                  7~14天
                  
                傷口類型:燒傷
                護理步驟:
                  將燒、燙傷部位用冷水沖洗或浸於冷水中約20分鐘,
                  若傷口未消腫，則脫除戒指、皮帶、鞋子或其它緊身衣物,
                  不可在傷口處擦拭黏性敷料、乳液、軟膏,
                  若有起水泡，注意不可將水泡搓破
                癒合時間:
                  8~30天
                  
                傷口類型:割傷
                護理步驟:
                  在傷口處放一塊乾淨且能吸水的布，以手壓緊,
                  將受傷的地方高舉超過心臟,
                  止血後用乾淨的開水或生理食鹽水輕輕洗淨
                癒合時間:
                  7~10天
                '''
            },
            {
              "role": "user",
              "content": '''
                傷口類型: $woundType，
                描述: 
                  我的年齡為$age歲，
                  我有$diseases，
                  並且${freqs[0]}抽菸、${freqs[1]}喝酒、${freqs[2]}嚼檳榔，請幫我估算傷口癒合時間。'''
            }
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(decodedBody);
        final String content = data["choices"][0]["message"]["content"];
        //解析內容
        String steps = '';
        String healTime = '';

        if (content.contains('護理步驟') && content.contains('癒合時間')) {
          final parts = content.split('癒合時間:');
          final beforeHeal = parts[0];
          healTime = parts.length > 1 ? parts[1].trim() : '';

          final stepIndex = beforeHeal.indexOf('護理步驟:');
          if (stepIndex != -1) {
            steps = beforeHeal.substring(stepIndex + '護理步驟:'.length).trim().replaceAll(' ','');
          }
        }

        return {
          'steps': steps,
          'healTime': healTime,
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
