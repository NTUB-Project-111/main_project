import 'package:drw/backend/models/report.dart';

class UserInfo {
  final int id;
  final String name;
  final String birthday;
  final String email;
  final String disease;
  final String freq;
  List<UserReport> reports;

  UserInfo({
    required this.id,
    required this.name,
    required this.birthday,
    required this.email,
    required this.disease,
    required this.freq,
    required this.reports,
  });

  UserInfo copyWith({
    String? name,
    String? gender,
    String? birthday,
    String? picture,
    String? email,
    String? disease,
    String? freq,
    List<UserReport>? reports,
  }) {
    return UserInfo(
      id: id,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      email: email ?? this.email,
      disease: disease ?? this.disease,
      freq: freq ?? this.freq,
      reports: reports ?? this.reports,
    );
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      email: json['email'],
      disease: json['disease'],
      freq: json['freq'],
      reports:
          (json['reports'] as List).map((reportJson) => UserReport.fromJson(reportJson)).toList(),
    );
  }

  // String? get role => null;

  @override
  String toString() {
    return '''
      === 使用者資料 === 
      id: $id
      姓名: $name
      生日: $birthday
      Email: $email
      疾病: $disease
      習慣頻率: $freq
    ''';
  }
}
