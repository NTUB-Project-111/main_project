import 'package:flutter/material.dart';

class UserFamily {
  final int memberId;
  final int userId;
  final String role;
  final int birthyear;
  final String disease;
  final String freq;

  UserFamily(
      {required this.memberId,
      required this.userId,
      required this.role,
      required this.birthyear,
      required this.disease,
      required this.freq});

  UserFamily copyWith(
      {int? memberId, int? userId, String? role, int? birthyear, String? disease, String? freq}) {
    return UserFamily(
        memberId: memberId ?? this.memberId,
        userId: userId ?? this.userId,
        role: role ?? this.role,
        birthyear: birthyear ?? this.birthyear,
        disease: disease ?? this.disease,
        freq: freq ?? this.freq);
  }

  factory UserFamily.fromJson(Map<String, dynamic> json) {
    
    return UserFamily(
        memberId: json['member_id'],
        userId: json['user_id'],
        role: json['role'],
        birthyear: json['birthyear'],
        disease: json['disease'],
        freq: json['freq']);
  }

  @override
  String toString() {
    return '''
      === 家庭資料 === 
      成員id: $memberId
      使用者id: $userId
      家庭身分: $role
      出生年份: $birthyear
      疾病: $disease
      習慣頻率: $freq
    ''';
  }
}
