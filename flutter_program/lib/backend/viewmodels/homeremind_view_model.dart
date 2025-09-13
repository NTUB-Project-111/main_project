import 'package:drw/backend/models/remind.dart';
import 'package:drw/backend/models/report.dart';

class HomeRemind {
  final int recordId;
  final int remindId;
  final String imagePath;
  final String woundType;
  final String remindDate;
  final String time;

  HomeRemind({
    required this.recordId,
    required this.remindId,
    required this.imagePath,
    required this.woundType,
    required this.remindDate,
    required this.time
  });

  static HomeRemind? fromReport(UserReport report, UserRemind remind) {
    return HomeRemind(
      recordId: report.id,
      remindId: remind.id,
      imagePath: report.photo,
      woundType: report.type,
      remindDate: remind.date,
      time: remind.time
    );
  }
}
