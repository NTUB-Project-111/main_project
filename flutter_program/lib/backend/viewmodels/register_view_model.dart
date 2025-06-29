import 'package:drw/backend/services/auth_service.dart';
import 'package:drw/frontend/views/auth_view.dart';
import 'package:flutter/material.dart';

class Register extends ChangeNotifier {
  String name = '';
  String email = '';
  String code = '';
  String password = '';
  String rePassword = '';

  final AuthService _authService = AuthService();

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setCode(String value) {
    code = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setRePassword(String value) {
    rePassword = value;
    notifyListeners();
  }

  //發送驗證碼
  Future<String?> sendCode() async {
    if (email.trim().isEmpty) return '請輸入Email';
    if (!Auth.validateEmail(email)) return '無效的Email格式';
    final error = await _authService.sendCode(email.trim());
    return error; // null 表示成功，其它是錯誤訊息
  }

  //驗證驗證碼
  Future<String?> verifyCode() async {
    if (code.trim().isEmpty) return '請輸入驗證碼';
    final error = await _authService.verifyCode(email, code);
    return error; // null 表示成功，其它是錯誤訊息
  }

  String? verify() {
    if (name.isEmpty || email.isEmpty || code.isEmpty || password.isEmpty || rePassword.isEmpty) {
      return '請輸入完整資訊';
    }
    if (!Auth.validatePassword(password)) return '請輸入8至16位的英文字母及數字組合';
    if (!Auth.verifyPassword(password, rePassword)) return '密碼不一致，請重新輸入';
    return null;
  }

  // Future<String?> register() async {
  //   if (!Auth.validatePassword(password)) return '請輸入8至16位的英文字母及數字組合';
  //   if (!Auth.verifyPassword(password, rePassword)) return '密碼不一致，請重新輸入';
  //   String formatted = formatBirthday(birthday!);
  //   isRegistering = true;
  //   notifyListeners();
  //   final error = await _authService.register(
  //       name: name,
  //       gender: gender,
  //       birthday: formatted,
  //       email: email,
  //       password: password,
  //       imageFile: picture);
  //   isRegistering = false;
  //   notifyListeners();
  //   return error;
  // }
}
