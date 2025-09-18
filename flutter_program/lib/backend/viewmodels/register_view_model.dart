import 'package:drw/backend/services/auth_service.dart';
import 'package:drw/frontend/utility/auth_util.dart';
import 'package:flutter/material.dart';

class Register extends ChangeNotifier {
  String name = '';
  String email = '';
  String code = '';
  String password = '';
  String rePassword = '';
  int birthday = 2025;
  String smokingFreq = '無';
  String drinkingFreq = '無';
  String betelNutFreq = '無';
  List<String> diseases = ['無'];

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

  void setBirthday(int value) {
    birthday = value;
    notifyListeners();
  }

  void setSmokingFreq(String value) {
    smokingFreq = value;
    notifyListeners();
  }

  void setDrinkingFreq(String value) {
    drinkingFreq = value;
    notifyListeners();
  }

  void setBetelNutFreq(String value) {
    betelNutFreq = value;
    notifyListeners();
  }

  void setDisease(List<String> values) {
    diseases = values;
    notifyListeners();
  }

  //發送驗證碼
  Future<String?> sendCode() async {
    if (email.trim().isEmpty) return '請輸入Email';
    if (!Auth.validateEmail(email)) return '無效的Email格式';
    final result = await _authService.checkEmailExists(email);
    if (result['exists']) return result['message'];
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

  Future<String?> register() async {
    final error = await _authService.register(
        name: name,
        gender: 'F',
        birthday: birthday.toString(),
        email: email,
        password: password,
        imageFile: null,
        disease: diseases.toString(),
        freq: '$smokingFreq、$drinkingFreq、$betelNutFreq');
    return error;
  }
}
