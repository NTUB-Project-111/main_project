
import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String id = '';
  String name = '';
  String birthday = '';
  String gender = '';
  String picture = '';
  String email = '';

  // 從 JSON 建立 User 實例
  void getFromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'] ?? '';
    birthday = json['birthday'] ?? '';
    gender = json['gender'] ?? '';
    picture = json['picture'] ?? '';
    email = json['email'] ?? '';

    notifyListeners(); // 通知 UI 更新
  }

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
    ''';
  }
}
