import 'package:drw/backend/models/report.dart';

class UserInfo {
  final int id;
  final String name;
  final String gender;
  final String birthday;
  final String picture;
  final String email;
  List<UserReport> reports;

  UserInfo({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthday,
    required this.picture,
    required this.email,
    required this.reports,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      birthday: json['birthday'],
      picture: json['picture'],
      email: json['email'],
      reports:
          (json['reports'] as List).map((reportJson) => UserReport.fromJson(reportJson)).toList(),
    );
  }
}
