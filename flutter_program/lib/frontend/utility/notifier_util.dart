import 'package:drw/backend/models/remind.dart';
import 'package:drw/backend/provider/remind_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifier {
  static final _notifyPlugin = FlutterLocalNotificationsPlugin();
  static const _channelName = "me.liucx.demoNotification";

  static Future<void> initialize() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _notifyPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    tz.initializeTimeZones();
  }

  static Future<void> scheduleReminder(int id, DateTime dateTime) async {
    final scheduled = tz.TZDateTime.from(dateTime, tz.local);

    await _notifyPlugin.zonedSchedule(
      id,
      '護理提醒',
      '換藥時間到囉!',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelName,
          _channelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: scheduled.toIso8601String(),
    );
  }

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
        debugPrint("排程提醒失敗: $e");
      }
    }
  }

  static void _handleNotificationTap(NotificationResponse notificationResponse) {
    debugPrint("收到提醒：${notificationResponse.payload}");
  }

  ///取消所有排程通知
  static Future<void> cancelAllReminders() async {
    await _notifyPlugin.cancelAll();
    debugPrint("所有提醒已取消");
  }

  /// 查看所有已排程的通知（用於 debug）
  static Future<void> debugPrintAllScheduledReminders() async {
    final pending = await _notifyPlugin.pendingNotificationRequests();
    if (pending.isEmpty) {
      debugPrint("目前沒有任何排程通知");
    } else {
      debugPrint("已排程通知列表:");
      for (var notification in pending) {
        debugPrint(
            "ID: ${notification.id}, 時間: ${notification.payload}, 標題: ${notification.title}, 內容: ${notification.body}");
      }
    }
  }

  static Future<void> setRemind(BuildContext context) async {
    final userRemind = Provider.of<RemindProvider>(context, listen: false);
    final userReport = Provider.of<ReportProvider>(context, listen: false);

    final userCalls = userReport.reports
        .where((report) => report.ifcall == 'Y')
        .expand((report) => userRemind.reminds.where((remind) => remind.recordId == report.id))
        .toList();

    await cancelAllReminders();
    await scheduleReminders(userCalls);
    await debugPrintAllScheduledReminders();
  }
}

