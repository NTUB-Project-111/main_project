import 'package:drw/backend/models/family.dart';
import 'package:drw/backend/models/remind.dart';
import 'package:drw/backend/models/report.dart';
import 'package:flutter/material.dart';

class Family extends ChangeNotifier {
  List<UserReport> allReports = [];
  List<UserRemind> allReminds = [];
  List<UserFamily> allMembers = [];

  List<Map<String, dynamic>> selectedReports = [];
  List<Map<String, dynamic>> selectedReminds = [];
  List<Map<String, dynamic>> selectedRecommends = [];
  List<Map<String, dynamic>> selectedReportImages = [];

  int count = 0;
  String selectedRole = '全部';

  void setData(bool isFirstLoad, List<UserReport> reports, List<UserRemind> reminds,
      List<UserFamily> members) {
    allReports = reports;
    allReminds = reminds;
    allMembers = members;
    setReports();
    setReminds();
    setRecommends();
    setReportImages();
  }

  void setRole(String value) {
    selectedRole = value;
    count = 0;
    setReports();
    setReminds();
    setRecommends();
    setReportImages();
    notifyListeners();
  }

  void setReports() {
    selectedReports = [];
    for (var report in allReports) {
      final dateTime = DateTime.parse(report.date);
      String date = '${dateTime.month}/${dateTime.day}';
      for (var member in allMembers) {
        if (selectedRole == '全部') {
          if (member.memberId == report.memberId) {
            String role = member.role;
            selectedReports.add({
              "memberId": report.memberId,
              "role": role,
              "image": report.photo,
              "date": date,
              "type": report.type,
            });
            break;
          }
        } else {
          if (member.memberId == report.memberId && member.role == selectedRole) {
            String role = member.role;
            selectedReports.add({
              "memberId": report.memberId,
              "role": role,
              "image": report.photo,
              "date": date,
              "type": report.type,
            });
            break;
          }
        }
      }
    }
  }

  void setReminds() {
    selectedReminds = [];
    if (selectedRole == '全部') {
      for (var remind in allReminds) {
        for (var member in allMembers) {
          String today =
              '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
          final dateTime = DateTime.parse(remind.date);
          String remindDate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
          if (member.memberId == remind.memberId && today == remindDate) {
            String role = member.role;
            selectedReminds.add({
              "memberId": remind.memberId,
              "role": role,
              "date": remindDate,
              "time": remind.time,
              "done": false,
            });
            break;
          }
        }
      }
    } else {
      for (var remind in allReminds) {
        for (var member in allMembers) {
          if (member.memberId == remind.memberId && member.role == selectedRole) {
            String today =
                '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
            final dateTime = DateTime.parse(remind.date);
            String remindDate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
            if (today == remindDate) {
              String role = member.role;
              selectedReminds.add({
                "memberId": remind.memberId,
                "role": role,
                "date": remindDate,
                "time": remind.time,
                "done": false,
              });
              break;
            }
          }
        }
      }
    }
  }

  void setRecommends() {
    selectedRecommends = [];
    for (var report in allReports) {
      final dateTime = DateTime.parse(report.date);
      String date = '${dateTime.month}/${dateTime.day}';
      for (var member in allMembers) {
        if (selectedRole == '全部') {
          if (member.memberId == report.memberId && report.ifcall == 'N') {
            selectedRecommends.add({"date": date, "image": report.photo});
            break;
          }
        } else {
          if (member.memberId == report.memberId &&
              member.role == selectedRole &&
              report.ifcall == 'N') {
            selectedRecommends.add({"date": date, "image": report.photo});
            break;
          }
        }
      }
    }
  }

  void setReportImages() {
    // 用於合併相同 year & month 的資料
    selectedReportImages = [];
    final Map<String, Map<String, dynamic>> grouped = {};

    for (var report in allReports) {
      if (selectedRole == '全部' && report.oktime == '傷口已痊癒') {
        final dateTime = DateTime.parse(report.date);
        final year = dateTime.year;
        final month = dateTime.month;
        final key = "$year-$month";

        // 若該 year-month 尚未建立，先建立
        if (!grouped.containsKey(key)) {
          grouped[key] = {
            "year": year,
            "month": month,
            "images": <String>[],
          };
        }
        // 加入圖片
        grouped[key]!["images"].add(report.photo);
      } else {
        for (var member in allMembers) {
          if (member.role == selectedRole &&
              member.memberId == report.memberId &&
              report.oktime == '傷口已痊癒') {
            final dateTime = DateTime.parse(report.date);
            final year = dateTime.year;
            final month = dateTime.month;
            final key = "$year-$month";

            // 若該 year-month 尚未建立，先建立
            if (!grouped.containsKey(key)) {
              grouped[key] = {
                "year": year,
                "month": month,
                "images": <String>[],
              };
            }
            // 加入圖片
            grouped[key]!["images"].add(report.photo);
          }
        }
      }
    }

    // 輸出成 List
    selectedReportImages = grouped.values.toList();
  }

  void setRemindState(int index) {
    selectedReminds[index]['done'] = !selectedReminds[index]['done'];
    count = selectedReminds.where((r) => r["done"]).length;
    notifyListeners();
  }
}
