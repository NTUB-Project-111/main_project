import 'package:drw/backend/services/oktime_update.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String result = '';

  Future<void> testGetCareSteps() async {
    String woundType = "擦傷";
    String birthday = "1990"; // 出生年
    String disease = "[糖尿病, 高血壓]"; // 字串形式
    String freq = "偶爾 (每週1~6根)、經常、偶爾 (每月1~5次)"; // 抽菸、喝酒、嚼檳榔

    Map<String, String>? response =
        await CareInfo.getCareSteps(woundType, birthday, disease, freq);
    setState(() {
      result = response != null
          ? "護理步驟:\n${response['steps']}\n\n癒合時間: ${response['healTime']}"
          : "取得失敗";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("測試 Care Steps")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: testGetCareSteps,
              child: const Text("執行 getCareSteps 測試"),
            ),
            const SizedBox(height: 20),
            const Text("結果：", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
