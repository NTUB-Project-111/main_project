import 'package:drw/backend/models/report.dart';

class UserInfo {
  final int id;
  final String name;
  final String gender;
  final String birthday;
  final String picture;
  final String email;
  final String disease;
  final String freq;
  List<UserReport> reports;

  UserInfo({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthday,
    required this.picture,
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
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      picture: picture ?? this.picture,
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
      gender: json['gender'],
      birthday: json['birthday'],
      picture: json['picture'] ?? '',
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
      性別: $gender
      照片路徑: $picture
      Email: $email
      疾病: $disease
      習慣頻率: $freq
    ''';
  }
}
