import 'package:drw/frontend/utility/notifier_util.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("生成護理圖片")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // final now = DateTime.now();
                // DateTime futureTime = now.add(const Duration(seconds: 10));
                // await NotifierTool.scheduleReminder(1, futureTime);
                // debugPrint("已設定通知: $futureTime");
                await NotifierTool.notifyNow();
              },
              child: const Text("設定 10 秒後提醒"),
            ),
          ],
        ),
      ),
    );
  }
}
