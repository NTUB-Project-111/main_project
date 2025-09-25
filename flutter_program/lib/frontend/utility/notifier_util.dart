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

  import 'package:drw/backend/models/remind.dart';
  import 'package:drw/backend/provider/remind_provider.dart';
  import 'package:drw/backend/provider/report_provider.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  import 'package:permission_handler/permission_handler.dart';
  import 'package:provider/provider.dart';
  import 'package:timezone/data/latest_all.dart' as tz;
  import 'package:timezone/timezone.dart' as tz;
  import 'package:intl/intl.dart';

  class Notifier {
    static final _notifyPlugin = FlutterLocalNotificationsPlugin();

    static const _channelId = "reminder_channel";
    static const _channelName = "Reminder Notifications";

    /// 初始化通知系統
    static Future<void> initialize() async {
      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );

      await _notifyPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      tz.initializeTimeZones();

      // Android 13+ 請求通知權限
      if (!await Permission.notification.isGranted) {
        await Permission.notification.request();
      }
    }

    /// 排程單筆提醒
    static Future<bool> scheduleReminder(int id, DateTime dateTime) async {
      // 先檢查通知權限
      if (!await Permission.notification.isGranted) {
        final result = await Permission.notification.request();
        if (!result.isGranted) {
          debugPrint("❌ 通知權限未授權，排程失敗");
          return false;
        }
      }

      try {
        final scheduled =
            tz.TZDateTime.from(dateTime, tz.getLocation('Asia/Taipei'));

        await _notifyPlugin.zonedSchedule(
          id,
          '護理提醒',
          '換藥時間到囉!',
          scheduled,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: scheduled.toIso8601String(),
        );

        // 格式化當地時間
        final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(scheduled);
        debugPrint("✅ 通知已排程 (ID: $id, 當地時間: $formatted)");
        return true;
      } catch (e) {
        debugPrint("❌ 排程通知失敗: $e");
        return false;
      }
    }

    /// 批次排程提醒
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

    /// 點擊通知時的回調
    static void _handleNotificationTap(
        NotificationResponse notificationResponse) {
      debugPrint("🔔 收到提醒：${notificationResponse.payload}");
    }

    /// 取消所有排程通知
    static Future<void> cancelAllReminders() async {
      await _notifyPlugin.cancelAll();
      debugPrint("🗑️ 所有提醒已取消");
    }

    /// 查看所有已排程的通知（debug 用）
    static Future<void> debugPrintAllScheduledReminders() async {
      final pending = await _notifyPlugin.pendingNotificationRequests();
      if (pending.isEmpty) {
        debugPrint("📭 目前沒有任何排程通知");
      } else {
        debugPrint("📌 已排程通知列表:");
        for (var notification in pending) {
          String localTime = "未知";
          Duration? diff;

          if (notification.payload != null) {
            try {
              final utcTime = DateTime.parse(notification.payload!);
              final localDateTime = utcTime.toLocal();
              localTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(localDateTime);
              diff = localDateTime.difference(DateTime.now());
            } catch (_) {}
          }

          debugPrint(
            "➡️ ID: ${notification.id}, 時間(當地): $localTime, "
            "剩餘: ${diff != null ? '${diff.inSeconds} 秒' : '未知'}, "
            "標題: ${notification.title}, 內容: ${notification.body}",
          );
        }
      }
    }

    /// 重新設定提醒（依據 Provider 資料）
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
