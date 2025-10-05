import 'package:drw/backend/models/remind.dart';
import 'package:drw/backend/provider/remind_provider.dart';
import 'package:drw/backend/provider/report_provider.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
// import 'package:timezone/data/latest_all.dart' as tz;

import 'package:timezone/timezone.dart' as tz;
import 'package:device_calendar/device_calendar.dart';

class Notifier {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  /// 取得預設行事曆
  Future<Calendar?> _getDefaultCalendar() async {
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && !(permissionsGranted.data ?? false)) {
      permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      if (!permissionsGranted.isSuccess || !(permissionsGranted.data ?? false)) {
        return null;
      }
    }

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    final calendars = calendarsResult.data;
    if (calendars == null || calendars.isEmpty) return null;
    return calendars.first;
  }

  /// 新增護理提醒
  Future<bool> addReminder(DateTime remindTime) async {
    final calendar = await _getDefaultCalendar();
    if (calendar == null) return false;

    final startDateTime = remindTime;
    final endDateTime = startDateTime.add(const Duration(minutes: 1));

    final location = tz.local;
    final tzStart = tz.TZDateTime.from(startDateTime, location);
    final tzEnd = tz.TZDateTime.from(endDateTime, location);

    final event = Event(
      calendar.id,
      title: '記得幫傷口換藥喔',
      description: '定期換藥會幫助傷口更快癒合喔！',
      start: tzStart,
      end: tzEnd,
    );
    event.reminders = [Reminder(minutes: 0)];

    final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    return result?.isSuccess ?? false;
  }

  Future<void> scheduleReminders(List<UserRemind> userCalls) async {
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
          await addReminder(rawDateTime);
        }
      } catch (e) {
        debugPrint("排程提醒失敗: $e");
      }
    }
  }

  /// 查看所有護理提醒（不回傳值，只印出）
  Future<void> getAllReminders() async {
    final calendar = await _getDefaultCalendar();
    if (calendar == null) return;

    final now = DateTime.now();
    final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
      calendar.id,
      RetrieveEventsParams(
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 365)),
      ),
    );

    final events = eventsResult.data ?? [];
    final nursingEvents = events.where((e) => e.title == '記得幫傷口換藥喔').toList();

    if (nursingEvents.isEmpty) {
      debugPrint('目前沒有排定的護理提醒。');
    } else {
      for (final e in nursingEvents) {
        debugPrint('護理提醒: 標題=${e.title}, 開始=${e.start}, 結束=${e.end}, ID=${e.eventId}');
      }
    }
  }

  /// 刪除所有護理提醒
  Future<void> deleteAllReminders() async {
    final calendar = await _getDefaultCalendar();
    if (calendar == null) return;

    final now = DateTime.now();
    final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
      calendar.id,
      RetrieveEventsParams(
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 365)),
      ),
    );

    final events = eventsResult.data ?? [];
    final nursingEvents = events.where((e) => e.title == '記得幫傷口換藥喔').toList();

    if (nursingEvents.isEmpty) {
      debugPrint('目前沒有可刪除的護理提醒。');
      return;
    }

    for (final e in nursingEvents) {
      if (e.eventId != null) {
        await _deviceCalendarPlugin.deleteEvent(calendar.id, e.eventId!);
        debugPrint('已刪除護理提醒：標題=${e.title}, ID=${e.eventId}');
      }
    }

    debugPrint('所有護理提醒已成功刪除！');
  }

  Future<void> setRemind(BuildContext context) async {
    final userRemind = Provider.of<RemindProvider>(context, listen: false);
    final userReport = Provider.of<ReportProvider>(context, listen: false);

    final userCalls = userReport.reports
        .where((report) => report.ifcall == 'Y')
        .expand((report) => userRemind.reminds.where((remind) => remind.recordId == report.id))
        .toList();

    await deleteAllReminders();
    await scheduleReminders(userCalls);
    await getAllReminders();
  }
}
