import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../../frontend/views/auth_view.dart';

class Register extends ChangeNotifier {
  String name = '';
  DateTime? birthday;
  String gender = '';
  File? picture;
  String email = '';
  String code = '';
  String password = '';
  String rePassword = '';
  bool isSending = false;
  bool isRegistering = false;
  bool showVerification = false;
  bool showPassword = false;
  bool hiddenPassword = true;
  bool hiddenrePassword = true;

  final AuthService _authService = AuthService();

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setrePassword(String value) {
    rePassword = value;
    notifyListeners();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setBirthday(DateTime date) {
    birthday = date;
    notifyListeners();
  }

  void setCode(String value) {
    code = value;
    notifyListeners();
  }

  void setProfileImage(File imageFile) {
    picture = imageFile;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void togglehiddenPassword() {
    hiddenPassword = !hiddenPassword;
    notifyListeners();
  }

  void togglehiddenRePassword() {
    hiddenrePassword = !hiddenrePassword;
    notifyListeners();
  }

  bool isFilled() {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        gender.isNotEmpty &&
        password.isNotEmpty &&
        rePassword.isNotEmpty &&
        code.isNotEmpty &&
        birthday != null;
  }

  String formatBirthday(DateTime birthday) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(birthday);
  }

  Future<String?> sendCode() async {
    if (email.trim().isEmpty) return '請輸入Email';
    if (!Auth.validateEmail(email)) return '無效的Email格式';
    isSending = true;
    notifyListeners();
    final error = await _authService.sendCode(email.trim());
    isSending = false;
    notifyListeners();
    return error; // null 表示成功，其它是錯誤訊息
  }

  Future<String?> verifyCode() async {
    if (code.trim().isEmpty) return '請輸入驗證碼';
    final error = await _authService.verifyCode(email, code);
    isSending = false;
    notifyListeners();
    return error; // null 表示成功，其它是錯誤訊息
  }

  Future<String?> register() async {
    if (!Auth.validatePassword(password)) return '請輸入8至16位的英文字母及數字組合';
    if (!Auth.verifyPassword(password, rePassword)) return '密碼不一致，請重新輸入';
    String formatted = formatBirthday(birthday!);
    isRegistering = true;
    notifyListeners();
    final error = await _authService.register(
        name: name, gender: gender, birthday: formatted, email: email, password: password);
    isRegistering = false;
    notifyListeners();
    return error;
  }

  @override
  String toString() {
    return '''
      === 註冊資料 ===
      姓名: $name
      生日: ${birthday != null ? birthday!.toIso8601String().split('T').first : '未選擇'}
      性別: $gender
      照片路徑: ${picture?.path ?? '未上傳'}
      Email: $email
      密碼: $password
      確認密碼: $rePassword
      ================
      ''';
  }
}
