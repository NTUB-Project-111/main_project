import 'package:drw/backend/models/report.dart';

class Gallery {
  List<List<UserReport>> reports = [];

  void setGroup(List<UserReport> userReports) {
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
    for (var group in reports) {
      if (group.length > 1) {
        group.sort((a, b) {
          final da = DateTime.tryParse(a.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
          final db = DateTime.tryParse(b.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
          return da.compareTo(db);
        });
      }
    }
  }

  /// Sort reports by their `date` field.
  ///
  /// If [descending] is true (default) the newest reports come first (大到小).
  /// If false, the oldest reports come first (小到大).
  List<UserReport> sortReport(List<UserReport> userReports, {bool descending = true}) {
    final sortedReports = List<UserReport>.from(userReports);

    sortedReports.sort((a, b) {
      final da = DateTime.tryParse(a.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = DateTime.tryParse(b.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final cmp = da.compareTo(db);
      // cmp < 0 when a is earlier than b
      return descending ? -cmp : cmp;
    });

    return sortedReports;
  }
}
