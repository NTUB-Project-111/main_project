import 'package:drw/backend/models/remind.dart';
import 'package:drw/frontend/utility/notifier_util.dart';
import 'package:flutter/material.dart';
// import 'package:device_calendar/device_calendar.dart';
// import 'package:timezone/timezone.dart' as tz;

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Notifier notifier = Notifier();
  late UserRemind remind;
  late List<UserRemind> remindList;

  @override
  void initState() {
    super.initState();
    remind =
        UserRemind(id: 0, recordId: 1, userId: 1, date: '2025-09-26', time: '22:59', freq: '每天');
    remindList = [remind];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                notifier.scheduleReminders(remindList);
                // final remindTime = DateTime(2025, 9, 26, 19, 46);
                // _addCalendarEvent(remindTime);
              },
              child: const Text('新增特定時間提醒'),
            ),
            // ElevatedButton(
            //   onPressed: _viewAllEvents,
            //   child: const Text('查看所有提醒'),
            // ),
            // ElevatedButton(
            //   onPressed: _deleteAllEvents,
            //   child: const Text('刪除所有提醒'),
            // ),
          ],
        ),
      ),
    );
  }
}
