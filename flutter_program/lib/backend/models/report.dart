import 'package:drw/backend/models/remind.dart';

class UserReport {
  final int id;
  final int userId;
  final String date;
  final String type;
  final String oktime;
  final String caremode;
  final String ifcall;
  final String choosekind;
  final String recording;
  final String photo;
  final String name;
  final int groupId;
  List<UserRemind> reminds;

  UserReport({
    required this.id,
    required this.userId,
    required this.date,
    required this.type,
    required this.oktime,
    required this.caremode,
    required this.ifcall,
    required this.choosekind,
    required this.recording,
    required this.photo,
    required this.name,
    required this.groupId,
    required this.reminds,
  });

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      type: json['type'],
      oktime: json['oktime'],
      caremode: json['caremode'],
      ifcall: json['ifcall'],
      choosekind: json['choosekind'],
      recording: json['recording'],
      photo: json['photo'],
      name: json['name'] ?? '',
      groupId: json['group_id'] ?? 0,
      reminds: (json['reminds'] as List).map((r) => UserRemind.fromJson(r)).toList(),
    );
  }
}
