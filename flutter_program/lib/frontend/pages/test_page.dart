// import 'package:drw/frontend/utility/notifier_util.dart';
// import 'package:flutter/material.dart';

// class TestPage extends StatefulWidget {
//   const TestPage({super.key});

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("生成護理圖片")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 // final now = DateTime.now();
//                 // DateTime futureTime = now.add(const Duration(seconds: 10));
//                 // await NotifierTool.scheduleReminder(1, futureTime);
//                 // debugPrint("已設定通知: $futureTime");
//                 await NotifierTool.notifyNow();
//               },
//               child: const Text("設定 10 秒後提醒"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:drw/backend/services/careinfo_gpt.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String resultText = "尚未測試";

  Future<void> _testGetCareSteps() async {
    final result = await CareInfo.getCareSteps(
      "擦傷",   // woundType
      "1990",   // birthday (只放年份，會自動算年齡)
      "[高血壓]", // disease (模擬有疾病，格式和你原本的輸入一樣)
      "沒有、沒有、沒有", // freq (抽菸、喝酒、檳榔)
      false,   // isExtra
      null,    // oktime
      "2025-09-01", // date (受傷日期，格式 yyyy-MM-dd)
    );

    setState(() {
      resultText = result?.toString() ?? "回傳 null";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("測試 getCareSteps")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _testGetCareSteps,
              child: const Text("執行 getCareSteps 測試"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(resultText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

