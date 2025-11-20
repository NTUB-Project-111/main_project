import 'package:drw/backend/models/remind.dart';
import 'package:intl/intl.dart';

class UserReport {
  final int id;
  final int userId;
  final int memberId;
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
  final String role;
  final String bruiseType;

  List<UserRemind> reminds;

  UserReport({
    required this.id,
    required this.userId,
    required this.memberId,
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
    required this.role,
    required this.bruiseType,
    required this.reminds,
  });

  UserReport copyWith({
    int? id,
    int? userId,
    int? memberId,
    String? date,
    String? type,
    String? oktime,
    String? caremode,
    String? ifcall,
    String? choosekind,
    String? recording,
    String? photo,
    String? name,
    int? groupId,
    String? role,
    String? bruiseType,
    List<UserRemind>? reminds,
  }) {
    return UserReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      type: type ?? this.type,
      oktime: oktime ?? this.oktime,
      caremode: caremode ?? this.caremode,
      ifcall: ifcall ?? this.ifcall,
      choosekind: choosekind ?? this.choosekind,
      recording: recording ?? this.recording,
      photo: photo ?? this.photo,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      role: role ?? this.role,
      bruiseType: bruiseType ?? this.bruiseType,
      reminds: reminds ?? this.reminds,
    );
  }

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      id: json['id_record'],
      userId: json['fk_userid'],
      memberId: json['member_id'],
      date: DateFormat('yyyy-MM-dd').format(DateTime.parse(json['date'])),
      type: json['type'],
      oktime: json['oktime'],
      caremode: json['caremode'],
      ifcall: json['ifcall'],
      choosekind: json['choosekind'],
      recording: json['recording'],
      photo: json['photo'],
      name: json['name'] ?? '',
      groupId: json['group_id'] ?? 0,
      role: json['role'] ?? '',
      bruiseType: json['bruise_type'] ?? '',
      reminds:
          (json['reminds'] as List<dynamic>?)?.map((r) => UserRemind.fromJson(r)).toList() ?? [],
    );
  }

  // @override
  // String toString() {
  //   final remindSummary = reminds.isEmpty
  //       ? '[]'
  //       : '[${reminds.map((r) => '${r.date} ${r.time}').join(', ')}]';
  //   return 'UserReport{id: $id, userId: $userId, memberId: $memberId, date: $date, type: $type, oktime: $oktime, caremode: $caremode, ifcall: $ifcall, name: $name, groupId: $groupId, role: $role, bruiseType: $bruiseType, reminds: $remindSummary}';
  // }

  
}
