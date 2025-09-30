import 'package:flutter/material.dart';
import '../models/remind.dart';

class RemindProvider extends ChangeNotifier {
  List<UserRemind> _reminds = [];

  List<UserRemind> get reminds => _reminds;

  void setReminds(List<UserRemind> reminds) {
    _reminds = reminds;
    notifyListeners();
  }

  void addRemind(UserRemind remind) {
    _reminds.add(remind);
    notifyListeners();
  }

  void addReminds(List<UserRemind> reminds) {
    _reminds.addAll(reminds);
    notifyListeners();
  }

  void removeRemind(int remindId) {
    _reminds.removeWhere((r) => r.id == remindId);
    notifyListeners();
  }

  List<UserRemind> remindsForReport(int reportId) {
    return _reminds.where((r) => r.recordId == reportId).toList(); // 假設你擴充了 reportId 欄位
  }
}
