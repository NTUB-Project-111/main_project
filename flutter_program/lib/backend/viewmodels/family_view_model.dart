import 'package:drw/backend/models/family.dart';
import 'package:drw/backend/models/remind.dart';
import 'package:drw/backend/models/report.dart';
import 'package:flutter/material.dart';

class Family extends ChangeNotifier {
  List<Map<String, dynamic>> reminders = [];
  List<Map<String, dynamic>> recommended = [];
  List<Map<String, dynamic>> newReminders = [];
  int count = 0;
  // int? countRemind;

  void setReminders(int? selectedMember, String? selectedRole, List<UserRemind> reminds,
      List<UserFamily> members, List<UserReport> reports) {
    reminders.clear();
    recommended.clear();
    count = 0;
    if (selectedMember == null) {
      for (var remind in reminds) {
        // final dateTime = DateTime.parse(remind.date);
        for (var member in members) {
          if (member.memberId == remind.memberId &&
              remind.date ==
                  '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}') {
            reminders.add({"time": remind.time, "member": member.role, "done": false});
          }
        }
      }
      for (var report in reports) {
        if (report.ifcall == 'N') {
          final dateTime = DateTime.parse(report.date);
          String date = '${dateTime.month}/${dateTime.day}';
          recommended.add({"date": date, "image": report.photo});
        }
      }
    } else {
      for (var remind in reminds) {
        if (selectedMember == remind.memberId &&
            remind.date ==
                '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}') {
          reminders.add({"time": remind.time, "member": selectedRole, "done": false});
        }
      }
      for (var report in reports) {
        if (report.ifcall == 'N' && report.memberId == selectedMember) {
          final dateTime = DateTime.parse(report.date);
          String date = '${dateTime.month}/${dateTime.day}';
          recommended.add({"date": date, "image": report.photo});
        }
      }
    }
    // debugPrint(reminders.toString());
  }

  void updateReminder(int index, bool value) {
    newReminders = newReminders.isEmpty
        ? reminders.map((item) => Map<String, dynamic>.from(item)).toList()
        : newReminders.map((item) => Map<String, dynamic>.from(item)).toList();
    newReminders[index]['done'] = value;
    // count = countRemind ?? count;
    count = newReminders.where((r) => r["done"]).length;

    // countRemind = count;
    debugPrint(count.toString());
    notifyListeners();
  }
}
