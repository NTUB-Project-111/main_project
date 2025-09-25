import 'package:flutter/material.dart';
import 'package:drw/frontend/utility/notifier_util.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // void _showSystemReminder() async {
  //   final remindTime = DateTime.now().add(const Duration(seconds: 5));
  //   await Notifier.scheduleReminder(0, remindTime);
  //   // await Notifier.scheduleReminder(9999, remindTime);
  //   if (mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('5秒後將發送系統提醒')),
  //     );
  //   }
  // }
  void _showSystemReminder() async {
    final remindTime = DateTime.now().add(const Duration(seconds: 10));
    final success = await Notifier.scheduleReminder(0, remindTime);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? '✅ 已成功排程：10秒後提醒' : '❌ 排程失敗，請檢查通知權限或設定',
        ),
      ),
    );
  }

  @override
  // void initState() {
  //   super.initState();
  //   Notifier.initialize(); // 初始化通知
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showSystemReminder,
          child: const Text('10秒後系統提醒'),
        ),
      ),
    );
  }
}
