import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class Login extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoading = false;
  String? _accessToken;
  bool get isLoggedIn => _accessToken != null;
  String? get accessToken => _accessToken;
  final AuthService _authService = AuthService();

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  bool isFilled() {
    return email.isNotEmpty && password.isNotEmpty;
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners(); // 通知 UI 開始 loading

    try {
      final token = await _authService.login(email, password);
      _accessToken = token;
      
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners(); // 通知 UI 結束 loading
    }
  }

  void logout() {
    _accessToken = null;
    notifyListeners();
  }

  @override
  String toString() {
    return '''
      === 登入資料 ===
      帳號: $email
      密碼: $password
      ================
      ''';
  }
}
