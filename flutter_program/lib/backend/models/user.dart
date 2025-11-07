import 'package:drw/backend/models/report.dart';

class UserInfo {
  final int id;
  final String name;
  final String birthday;
  final String email;
  final String disease;
  final String freq;
  final String role;
  final String password;
  List<UserReport> reports;

  UserInfo({
    required this.id,
    required this.name,
    required this.birthday,
    required this.email,
    required this.disease,
    required this.freq,
    required this.role,
    required this.password,
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
    String? role,
    String? password,
    List<UserReport>? reports,
  }) {
    return UserInfo(
      id: id,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      email: email ?? this.email,
      disease: disease ?? this.disease,
      freq: freq ?? this.freq,
      role: role ?? this.role,
      password: password ?? this.password,
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
      role: json['role'],
      password: json['password'],
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
