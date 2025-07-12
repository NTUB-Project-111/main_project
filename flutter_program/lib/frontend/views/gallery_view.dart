import 'package:drw/backend/models/report.dart';

class Gallery {
  List<List<UserReport>> reports = [];

  void sortReports(List<UserReport> userReports) {
    for (var report in userReports) {
      bool found = false;
      for (var group in reports) {
        if (group.first.groupId == report.groupId && report.groupId != 0) {
          group.add(report);
          found = true;
          break;
        }
      }
      if (!found) {
        reports.add([report]);
      }
    }
  }
}
