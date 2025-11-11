import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class Login extends ChangeNotifier {
  String email = '';
  String password = '';
  // bool isLoading = false;
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
    // isLoading = true;
    // notifyListeners();
    try {
      final token = await _authService.login(email, password);
      _accessToken = token;
      return true;
    } catch (e) {
      debugPrint('login 發生錯誤: $e');
      return false;
    } finally {
      // isLoading = false;
      // notifyListeners(); 
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
