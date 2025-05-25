import 'dart:convert';
import 'package:http/http.dart' as http;

class HealingTime {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static const String apiKey = ""; //放APIKey

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
                  "你是一位專業的醫療助理，根據傷口類型與描述，預測其大約癒合時間並回答，只須回答癒合時間並以天數為單位，不需要回答其他文字敘述，例如:4~10天、7天、5~7天"
            },
            {
              "role": "user",
              "content":
                  "傷口類型: $woundType$part$rection，描述: $description，請幫我估算癒合時間。"
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
}
