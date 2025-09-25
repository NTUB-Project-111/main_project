// import 'package:flutter/material.dart';
// import 'package:drw/frontend/utility/notifier_util.dart';

// class TestPage extends StatefulWidget {
//   const TestPage({super.key});

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   // void _showSystemReminder() async {
//   //   final remindTime = DateTime.now().add(const Duration(seconds: 5));
//   //   await Notifier.scheduleReminder(0, remindTime);
//   //   // await Notifier.scheduleReminder(9999, remindTime);
//   //   if (mounted) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('5秒後將發送系統提醒')),
//   //     );
//   //   }
//   // }
//   void _showSystemReminder() async {
//     final remindTime = DateTime.now().add(const Duration(seconds: 10));
//     final success = await Notifier.scheduleReminder(0, remindTime);

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           success ? '✅ 已成功排程：10秒後提醒' : '❌ 排程失敗，請檢查通知權限或設定',
//         ),
//       ),
//     );
//   }

//   @override
//   // void initState() {
//   //   super.initState();
//   //   Notifier.initialize(); // 初始化通知
//   // }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Test Page')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _showSystemReminder,
//           child: const Text('10秒後系統提醒'),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:drw/frontend/utility/notifier_util.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class TestPage extends StatefulWidget {
//   const TestPage({super.key});

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   @override
//   void initState() {
//     super.initState();
//     Notifier.initialize().then((_) async {
//       // 確認已註冊通知通道
//       final channels = await Notifier.plugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.getNotificationChannels();
//       debugPrint("📌 已註冊的通知通道: $channels");
//     });
//   }

//   /// 按鈕觸發：立即通知 + 10秒後排程
//   void _showSystemReminder() async {
//     // 立即顯示通知
//     await Notifier.plugin.show(
//       0,
//       '立即通知',
//       '這是立即測試通知',
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           Notifier.channelId,
//           Notifier.channelName,
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//     );

//     // 10秒後排程通知
//     final remindTime = DateTime.now().add(const Duration(seconds: 10));
//     final success = await Notifier.scheduleReminder(1, remindTime);

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           success ? '✅ 已成功排程：10秒後提醒' : '❌ 排程失敗，請檢查通知權限或設定',
//         ),
//       ),
//     );
//   }

//   /// Debug: 查看已排程通知
//   void _debugScheduledNotifications() async {
//     final pending = await Notifier.plugin.pendingNotificationRequests();

//     if (!mounted) return;

//     if (pending.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('目前沒有任何排程通知')),
//       );
//     } else {
//       for (var n in pending) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'ID: ${n.id}, 標題: ${n.title}, 內容: ${n.body}, payload: ${n.payload}',
//             ),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Test Page')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _showSystemReminder,
//               child: const Text('立即 + 10秒後通知'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _debugScheduledNotifications,
//               child: const Text('查看已排程通知 (Debug)'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//------------------------------------------------

//測試1

// import 'package:flutter/material.dart';
// import 'package:drw/frontend/utility/notifier_util.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class TestPage extends StatefulWidget {
//   const TestPage({super.key});

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   @override
//   void initState() {
//     super.initState();
//     // 初始化通知系統（只初始化一次）
//     Notifier.initialize();
//   }

//   /// 測試立即通知
//   Future<void> _showImmediateNotification() async {
//     await Notifier.showNotification1(
//       0,
//       '立即通知',
//       '立即通知測試',
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('✅ 已發送立即通知')),
//     );

//     // 顯示所有立即通知紀錄在 debug log
//     for (var log in Notifier.immediateNotificationLog) {
//       debugPrint(
//         '📌 ID:${log['id']}, Title:${log['title']}, Body:${log['body']}, Time:${log['time']}',
//       );
//     }
//   }

//   /// 測試 30 秒後排程通知
//   Future<void> _scheduleDelayedNotification() async {
//     final scheduledTime = tz.TZDateTime.from(
//       DateTime.now().add(const Duration(seconds: 5)),
//       tz.getLocation('Asia/Taipei'),
//     );

//     final success = await Notifier.scheduleReminder(2, scheduledTime);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           success ? '✅ 已排程：5 秒後通知' : '❌ 排程失敗，請檢查通知權限',
//         ),
//       ),
//     );
//     debugPrint("🕑 排程時間: $scheduledTime");
//   }

//   /// 查看所有已排程通知 (Debug)
//   Future<void> _debugScheduledNotifications() async {
//     final pending = await Notifier.plugin.pendingNotificationRequests();
//     if (pending.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('目前沒有任何排程通知')),
//       );
//     } else {
//       for (var n in pending) {
//         debugPrint(
//             '📌 ID: ${n.id}, 標題: ${n.title}, 內容: ${n.body}, payload: ${n.payload}');
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('📌 已列出所有排程通知，請查看 debug log')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Test Page')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _showImmediateNotification,
//               child: const Text('立即通知'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _scheduleDelayedNotification,
//               child: const Text('5秒後排程通知'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _debugScheduledNotifications,
//               child: const Text('查看已排程通知 (Debug)'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await Notifier.debugCheckTrigger(2);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('✅ 已檢查 Debug 結果，請看 Log')),
//                 );
//               },
//               child: const Text('Debug: 檢查通知是否觸發'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await Notifier.debugSystemStatus();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('📌 系統自檢完成，請查看 debug log')),
//                 );
//               },
//               child: const Text('🔍 系統自檢 Debug'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await Notifier.openBatteryOptimizationSettings();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('請手動允許 App 不受電池優化限制')),
//                 );
//               },
//               child: const Text('⚡ 開啟電池優化設定'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//------------------------------------------------

import 'package:flutter/material.dart';
import 'package:drw/frontend/utility/notifier_util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    // 初始化通知系統
    Notifier.initialize();
  }

  /// 測試立即通知 (直接呼叫 alarmCallback)
  Future<void> _showImmediateNotification() async {
    await Notifier.alarmCallback(0, {'type': 'immediate_test'});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 已發送立即通知')),
    );
  }

  /// 測試 30 秒後排程通知
  Future<void> _scheduleDelayedNotification() async {
    final scheduledTime = tz.TZDateTime.from(
      DateTime.now().add(const Duration(seconds: 30)),
      tz.getLocation('Asia/Taipei'),
    );

    await Notifier.scheduleReminder(1, scheduledTime);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 已排程：30 秒後通知')),
    );

    debugPrint("🕑 排程時間: $scheduledTime");
  }

  /// 查看所有已排程通知 (Debug)
  Future<void> _debugScheduledNotifications() async {
    await Notifier.debugPrintAllScheduledReminders();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📌 已列出所有排程通知，請查看 debug log')),
    );
  }

  /// 強制呼叫 alarmCallback 測試
  Future<void> _forceTriggerAlarm() async {
    await Notifier.alarmCallback(99, {'type': 'force_test'});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔔 強制觸發通知 (Debug)')),
    );
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
              onPressed: _showImmediateNotification,
              child: const Text('立即通知'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleDelayedNotification,
              child: const Text('30秒後排程通知'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _debugScheduledNotifications,
              child: const Text('查看已排程通知 (Debug)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _forceTriggerAlarm,
              child: const Text('Debug: 強制觸發通知'),
            ),
          ],
        ),
      ),
    );
  }
}
