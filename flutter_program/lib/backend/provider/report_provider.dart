import 'package:flutter/material.dart';
import '../models/report.dart';

class ReportProvider extends ChangeNotifier {
  List<UserReport> _reports = [];

  List<UserReport> get reports => _reports;

  void setReports(List<UserReport> reports) {
    _reports = reports;
    notifyListeners();
  }

  void addReport(UserReport report) {
    _reports.add(report);
    notifyListeners();
  }

  void updateReport(UserReport updatedReport) {
    final index = _reports.indexWhere((r) => r.id == updatedReport.id);
    if (index != -1) {
      _reports[index] = updatedReport;
      notifyListeners();
    }
  }

  void removeReport(int reportId) {
    _reports.removeWhere((r) => r.id == reportId);
    notifyListeners();
  }
}
