import 'package:flutter/material.dart';
import 'package:drw/frontend/utility/notifier_util.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  void _showSystemReminder() async {
    final now = DateTime.now();
    final remindTime = now.add(const Duration(seconds: 5));
    await Notifier.scheduleReminder(9999, remindTime);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('5秒後將發送系統提醒')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showSystemReminder,
          child: const Text('5秒後系統提醒'),
        ),
      ),
    );
  }
}