// import 'package:drw/backend/models/remind.dart';
// import 'package:drw/backend/provider/remind_provider.dart';
// import 'package:drw/backend/provider/report_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class Notifier {
//   static final _notifyPlugin = FlutterLocalNotificationsPlugin();
//   // static const _channelName = "me.liucx.demoNotification";
//   static const _channelId = "reminder_channel";
//   static const _channelName = "Reminder Notifications";

//   static Future<void> initialize() async {
//     // const initSettings = InitializationSettings(
//     //   android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     // );

//     // await _notifyPlugin.initialize(
//     //   initSettings,
//     //   onDidReceiveNotificationResponse: _handleNotificationTap,
//     // );

//     // tz.initializeTimeZones();
//     const initSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     );

//     await _notifyPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _handleNotificationTap,
//     );

//     tz.initializeTimeZones();

//     // Android 13+ 請求通知權限
//     if (await Permission.notification.isGranted) {
//       await Permission.notification.request();
//     }
//   }

//   // static Future<void> scheduleReminder(int id, DateTime dateTime) async {
//   //   final scheduled = tz.TZDateTime.from(dateTime, tz.local);

//   //   await _notifyPlugin.zonedSchedule(
//   //     id,
//   //     '護理提醒',
//   //     '換藥時間到囉!',
//   //     scheduled,
//   //     const NotificationDetails(
//   //       android: AndroidNotificationDetails(
//   //         _channelName,
//   //         _channelName,
//   //         importance: Importance.max,
//   //         priority: Priority.high,
//   //       ),
//   //     ),
//   //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   //     uiLocalNotificationDateInterpretation:
//   //         UILocalNotificationDateInterpretation.absoluteTime,
//   //     payload: scheduled.toIso8601String(),
//   //   );
//   // }
//   static Future<bool> scheduleReminder(int id, DateTime dateTime) async {
//     // 先檢查通知權限
//     if (!await Permission.notification.isGranted) {
//       final result = await Permission.notification.request();
//       if (!result.isGranted) {
//         debugPrint("❌ 通知權限未授權，排程失敗");
//         return false;
//       }
//     }

//     try {
//       final scheduled = tz.TZDateTime.from(dateTime, tz.local);

//       await _notifyPlugin.zonedSchedule(
//         id,
//         '護理提醒',
//         '換藥時間到囉!',
//         scheduled,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             "reminder_channel", // ✅ 建議使用簡單字串
//             "Reminder Notifications",
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//         androidScheduleMode:
//             AndroidScheduleMode.exactAllowWhileIdle, // ✅ 確保準時觸發
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         payload: scheduled.toIso8601String(),
//       );

//       debugPrint("✅ 通知已排程 (ID: $id, 當地時間: ${scheduled.toLocal()})");
//       return true;
//     } catch (e) {
//       debugPrint("❌ 排程通知失敗: $e");
//       return false;
//     }
//   }

//   // static Future<void> scheduleReminder(int id, DateTime dateTime) async {
//   //   // 先檢查通知權限
//   //   final status = await Permission.notification.status;
//   //   if (!status.isGranted) {
//   //     final result = await Permission.notification.request();
//   //     if (!result.isGranted) {
//   //       debugPrint("通知權限未授權，排程失敗");
//   //       return;
//   //     }
//   //   }

//   //   final scheduled = tz.TZDateTime.from(dateTime, tz.local);

//   //   await _notifyPlugin.zonedSchedule(
//   //     id,
//   //     '護理提醒',
//   //     '換藥時間到囉!',
//   //     scheduled,
//   //     const NotificationDetails(
//   //       android: AndroidNotificationDetails(
//   //         _channelName,
//   //         _channelName,
//   //         importance: Importance.max,
//   //         priority: Priority.high,
//   //       ),
//   //     ),
//   //     // androidScheduleMode: AndroidScheduleMode.inexact,
//   //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   //     uiLocalNotificationDateInterpretation:
//   //         UILocalNotificationDateInterpretation.absoluteTime,
//   //     payload: scheduled.toIso8601String(),
//   //   );
//   // }

//   static Future<void> scheduleReminders(List<UserRemind> userCalls) async {
//     for (int i = 0; i < userCalls.length; i++) {
//       final call = userCalls[i];
//       try {
//         final dateParts = call.date.split('-').map(int.parse).toList();
//         final timeParts = call.time.split(':').map(int.parse).toList();

//         final rawDateTime = DateTime(
//           dateParts[0],
//           dateParts[1],
//           dateParts[2],
//           timeParts[0],
//           timeParts[1],
//         );

//         if (rawDateTime.isAfter(DateTime.now())) {
//           await scheduleReminder(i, rawDateTime);
//         }
//       } catch (e) {
//         debugPrint("排程提醒失敗: $e");
//       }
//     }
//   }

//   static void _handleNotificationTap(
//       NotificationResponse notificationResponse) {
//     debugPrint("收到提醒：${notificationResponse.payload}");
//   }

//   ///取消所有排程通知
//   static Future<void> cancelAllReminders() async {
//     await _notifyPlugin.cancelAll();
//     debugPrint("所有提醒已取消");
//   }

//   /// 查看所有已排程的通知（用於 debug）
//   /// 查看所有已排程的通知（用於 debug）
//   static Future<void> debugPrintAllScheduledReminders() async {
//     final pending = await _notifyPlugin.pendingNotificationRequests();
//     if (pending.isEmpty) {
//       debugPrint("目前沒有任何排程通知");
//     } else {
//       debugPrint("已排程通知列表:");
//       for (var notification in pending) {
//         // 嘗試把 payload (UTC) 轉換成本地時間
//         String localTime = notification.payload ?? "未知";
//         try {
//           final utcTime = DateTime.parse(notification.payload!);
//           localTime = utcTime.toLocal().toString(); // 轉換為當地時間
//         } catch (_) {}

//         debugPrint(
//             "ID: ${notification.id}, 時間(當地): $localTime, 標題: ${notification.title}, 內容: ${notification.body}");
//       }
//     }
//   }

//   static Future<void> setRemind(BuildContext context) async {
//     final userRemind = Provider.of<RemindProvider>(context, listen: false);
//     final userReport = Provider.of<ReportProvider>(context, listen: false);

//     final userCalls = userReport.reports
//         .where((report) => report.ifcall == 'Y')
//         .expand((report) =>
//             userRemind.reminds.where((remind) => remind.recordId == report.id))
//         .toList();

//     await cancelAllReminders();
//     await scheduleReminders(userCalls);
//     await debugPrintAllScheduledReminders();
//   }
// }
//-------------------------------------------------------------

// 測試1

// import 'package:drw/backend/models/remind.dart';
// import 'package:drw/backend/provider/remind_provider.dart';
// import 'package:drw/backend/provider/report_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:intl/intl.dart';
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:android_intent_plus/flag.dart';
// import 'package:flutter/material.dart';

// class Notifier {
//   static final _notifyPlugin = FlutterLocalNotificationsPlugin();
//   static FlutterLocalNotificationsPlugin get plugin => _notifyPlugin;
//   static const _channelId = "reminder_channel";
//   static const _channelName = "Reminder Notifications";
//   static String get channelId => _channelId;
//   static String get channelName => _channelName;

//   /// 初始化通知系統
//   static Future<void> initialize() async {
//     // // ✅ 初始化時區 (一定要最前面)
//     // tz.initializeTimeZones();

//     const initSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     );

//     // 初始化 plugin
//     await _notifyPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _handleNotificationTap,
//     );

//     var channel = AndroidNotificationChannel(
//       channelId,
//       channelName,
//       description: 'App 的提醒通知',
//       importance: Importance.max,
//     );

//     // 建立 Android Channel
//     final androidPlugin = plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await androidPlugin?.createNotificationChannel(channel);

//     // 請求 Android 13+ 通知權限
//     final status = await Permission.notification.status;
//     if (status.isDenied || status.isRestricted) {
//       await Permission.notification.request();
//     }
//   }

//   /// 排程單筆提醒
//   static Future<bool> scheduleReminder(int id, DateTime dateTime) async {
//     // 先檢查通知權限
//     if (!await Permission.notification.isGranted) {
//       final result = await Permission.notification.request();
//       if (!result.isGranted) {
//         debugPrint("❌ 通知權限未授權，排程失敗");
//         return false;
//       }
//     }

//     try {
//       final scheduled =
//           tz.TZDateTime.from(dateTime, tz.getLocation('Asia/Taipei'));

//       await _notifyPlugin.zonedSchedule(
//         id,
//         '護理提醒',
//         '換藥時間到囉!',
//         scheduled,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             _channelId,
//             _channelName,
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             enableVibration: true,
//             // ticker: 'ticker',
//           ),
//         ),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         payload: scheduled.toIso8601String(),
//         // matchDateTimeComponents: DateTimeComponents.time, // 如果你想每天固定時間觸發
//         matchDateTimeComponents: null,
//       );
//       debugPrint("scheduled: $scheduled, now: ${DateTime.now()}");
//       final channels = await Notifier.plugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.getNotificationChannels();
//       debugPrint("channels: $channels");

//       // 格式化當地時間
//       final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(scheduled);
//       debugPrint("✅ 通知已排程 (ID: $id, 當地時間: $formatted)");
//       return true;
//     } catch (e) {
//       debugPrint("❌ 排程通知失敗: $e");
//       return false;
//     }
//   }

//   ///靜態方法觸發通知
//   static Future<void> showNotification(
//       int id, String title, String body) async {
//     await plugin.show(
//       id,
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channelId,
//           channelName,
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//     );
//   }

//   /// 批次排程提醒
//   static Future<void> scheduleReminders(List<UserRemind> userCalls) async {
//     for (int i = 0; i < userCalls.length; i++) {
//       final call = userCalls[i];
//       try {
//         final dateParts = call.date.split('-').map(int.parse).toList();
//         final timeParts = call.time.split(':').map(int.parse).toList();

//         final rawDateTime = DateTime(
//           dateParts[0],
//           dateParts[1],
//           dateParts[2],
//           timeParts[0],
//           timeParts[1],
//         );

//         if (rawDateTime.isAfter(DateTime.now())) {
//           await scheduleReminder(i, rawDateTime);
//         }
//       } catch (e) {
//         debugPrint("❌ 排程提醒失敗: $e");
//       }
//     }
//   }

//   /// 點擊通知時的回調
//   static void _handleNotificationTap(
//       NotificationResponse notificationResponse) {
//     debugPrint("🔔 收到提醒：${notificationResponse.payload}");
//   }

//   /// 取消所有排程通知
//   static Future<void> cancelAllReminders() async {
//     await _notifyPlugin.cancelAll();
//     debugPrint("🗑️ 所有提醒已取消");
//   }

//   /// 查看所有已排程的通知（debug 用）
//   static Future<void> debugPrintAllScheduledReminders() async {
//     final pending = await _notifyPlugin.pendingNotificationRequests();
//     if (pending.isEmpty) {
//       debugPrint("📭 目前沒有任何排程通知");
//     } else {
//       debugPrint("📌 已排程通知列表:");
//       for (var notification in pending) {
//         String localTime = "未知";
//         Duration? diff;

//         if (notification.payload != null) {
//           try {
//             final utcTime = DateTime.parse(notification.payload!);
//             final localDateTime = utcTime.toLocal();
//             localTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
//             diff = localDateTime.difference(DateTime.now());
//           } catch (_) {}
//         }

//         debugPrint(
//           "➡️ ID: ${notification.id}, 時間(當地): $localTime, "
//           "剩餘: ${diff != null ? '${diff.inSeconds} 秒' : '未知'}, "
//           "標題: ${notification.title}, 內容: ${notification.body}",
//         );
//       }
//     }
//   }

//   /// 重新設定提醒（依據 Provider 資料）
//   static Future<void> setRemind(BuildContext context) async {
//     final userRemind = Provider.of<RemindProvider>(context, listen: false);
//     final userReport = Provider.of<ReportProvider>(context, listen: false);

//     final userCalls = userReport.reports
//         .where((report) => report.ifcall == 'Y')
//         .expand((report) =>
//             userRemind.reminds.where((remind) => remind.recordId == report.id))
//         .toList();

//     await cancelAllReminders();
//     await scheduleReminders(userCalls);
//     await debugPrintAllScheduledReminders();
//   }

//   //debug

//   static List<Map<String, String>> immediateNotificationLog = [];

//   static Future<void> showNotification1(
//       int id, String title, String body) async {
//     await plugin.show(
//       id,
//       title,
//       body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channelId,
//           channelName,
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       payload: DateTime.now().toIso8601String(),
//     );

//     // 紀錄通知
//     immediateNotificationLog.add({
//       'id': id.toString(),
//       'title': title,
//       'body': body,
//       'time': DateTime.now().toIso8601String(),
//     });

//     debugPrint("📝 已發送立即通知，log: ${immediateNotificationLog.last}");
//   }

//   /// 跳轉到 Android 電池優化設定頁面
//   static Future<void> openBatteryOptimizationSettings() async {
//     try {
//       final intent = AndroidIntent(
//         action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
//         flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
//       );
//       await intent.launch();
//       debugPrint("✅ 已打開電池優化設定頁面，請手動允許 App 不受限制");
//     } catch (e) {
//       debugPrint("❌ 無法打開設定頁面: $e");
//     }
//   }

//   static Future<void> debugCheckTrigger(int id) async {
//     final pending = await _notifyPlugin.pendingNotificationRequests();

//     final found = pending.where((n) => n.id == id).toList();

//     if (found.isEmpty) {
//       debugPrint("✅ Debug: 通知 ID $id 已經被觸發或移除");
//     } else {
//       debugPrint("❌ Debug: 通知 ID $id 仍在排程中，尚未觸發");
//       for (var n in found) {
//         debugPrint(
//             "   ➡️ ID: ${n.id}, title: ${n.title}, body: ${n.body}, payload: ${n.payload}");
//       }
//     }
//   }

//   /// 系統自檢 debug 工具
// // /// 會列出：
// // — 所有 pending 通知
// // — 通知 channel 列表及重要性
//   /// ⚠️ Android 可用，不保證 iOS 顯示電池優化狀態
//   static Future<void> debugSystemStatus() async {
//     debugPrint("📌 ======= 系統自檢開始 =======");

//     // 1️⃣ Pending 通知
//     final pending = await _notifyPlugin.pendingNotificationRequests();
//     if (pending.isEmpty) {
//       debugPrint("📭 目前沒有任何排程通知");
//     } else {
//       debugPrint("📌 已排程通知列表:");
//       for (var n in pending) {
//         String localTime = "未知";
//         if (n.payload != null) {
//           try {
//             final utcTime = DateTime.parse(n.payload!);
//             localTime = utcTime.toLocal().toString();
//           } catch (_) {}
//         }
//         debugPrint(
//             "➡️ ID: ${n.id}, title: ${n.title}, body: ${n.body}, payload: ${n.payload}, 時間: $localTime");
//       }
//     }

//     // 2️⃣ Notification Channel 列表
//     final androidPlugin = plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     final channels = await androidPlugin?.getNotificationChannels();
//     if (channels == null || channels.isEmpty) {
//       debugPrint("❌ 找不到任何通知 channel");
//     } else {
//       debugPrint("📌 Notification Channels:");
//       for (var c in channels) {
//         debugPrint(
//             "➡️ id: ${c.id}, name: ${c.name}, importance: ${c.importance}, description: ${c.description}");
//       }
//     }

//     // 3️⃣ 電池優化狀態 (Android)
//     try {
//       // 需要 permission_handler + Android api > 23
//       final status = await Permission.ignoreBatteryOptimizations.status;
//       debugPrint("🔋 電池優化狀態: ${status.isGranted ? "已忽略 / 不受限制" : "受限制"}");
//     } catch (e) {
//       debugPrint("⚠️ 無法讀取電池優化狀態: $e");
//     }

//     debugPrint("📌 ======= 系統自檢結束 =======");
//   }
// }

//----------------------------------------------------------------

// 測試2

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:drw/backend/models/remind.dart';
import 'package:drw/backend/provider/remind_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Notifier {
  static const String channelId = 'reminder_channel';
  static const String channelName = 'Reminder Notifications';

  /// 初始化通知
  static Future<void> initialize() async {
    // 請求通知權限
    await Permission.notification.request();

    // 初始化 flutter_local_notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// 強制排程通知 (避開 Doze Mode)
  static Future<void> scheduleReminder(int id, DateTime dateTime) async {
    final duration = dateTime.difference(DateTime.now());
    if (duration.isNegative) return;

    await AndroidAlarmManager.oneShot(
      duration,
      id,
      alarmCallback,
      exact: true, // 精確時間
      wakeup: true, // 避開 Doze Mode
      allowWhileIdle: true, // 保證在休眠時也能觸發
      rescheduleOnReboot: false, // 重啟後自動重新排程
      params: {'id': id, 'scheduledTime': dateTime.toIso8601String()},
    );

    print('⏰ 強制排程 Alarm: $dateTime (ID: $id)');
  }

  /// 正確寫法，只有 positional 參數
  static Future<void> alarmCallback(
      int id, Map<String, dynamic>? params) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      '護理提醒',
      '換藥時間到囉!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
    );

    debugPrint(
        '🔔 Alarm triggered! ID: $id, params: $params at ${DateTime.now()}');
  }

  /// 批次排程
  static Future<void> scheduleReminders(List<UserRemind> userCalls) async {
    for (int i = 0; i < userCalls.length; i++) {
      final call = userCalls[i];
      try {
        final dateParts = call.date.split('-').map(int.parse).toList();
        final timeParts = call.time.split(':').map(int.parse).toList();

        final rawDateTime = DateTime(
          dateParts[0],
          dateParts[1],
          dateParts[2],
          timeParts[0],
          timeParts[1],
        );

        if (rawDateTime.isAfter(DateTime.now())) {
          await scheduleReminder(i, rawDateTime);
        }
      } catch (e) {
        debugPrint("❌ 排程提醒失敗: $e");
      }
    }
  }

  /// 取消所有通知
  static Future<void> cancelAllReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('🗑️ 所有提醒已取消');
  }

  /// 查看已排程通知
  static Future<void> debugPrintAllScheduledReminders() async {
    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (pending.isEmpty) {
      print('📭 目前沒有任何排程通知');
    } else {
      print('📌 已排程通知列表:');
      for (var notification in pending) {
        String localTime = "未知";
        try {
          final utcTime = DateTime.parse(notification.payload ?? '');
          final localDateTime = utcTime.toLocal();
          localTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
        } catch (_) {}
        print(
          "➡️ ID: ${notification.id}, 時間(當地): $localTime, "
          "標題: ${notification.title}, 內容: ${notification.body}",
        );
      }
    }
  }

  /// 依 Provider 重新排程
  static Future<void> setRemind(BuildContext context) async {
    final userRemind = Provider.of<RemindProvider>(context, listen: false);
    final userReport = Provider.of<ReportProvider>(context, listen: false);

    final userCalls = userReport.reports
        .where((report) => report.ifcall == 'Y')
        .expand((report) =>
            userRemind.reminds.where((remind) => remind.recordId == report.id))
        .toList();

    await cancelAllReminders();
    await scheduleReminders(userCalls);
    await debugPrintAllScheduledReminders();
  }
}
