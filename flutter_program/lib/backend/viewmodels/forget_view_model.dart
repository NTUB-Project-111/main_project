import 'package:flutter/material.dart';
import '../../frontend/views/auth_view.dart';
import '../services/auth_service.dart';

class Forget extends ChangeNotifier {
  String email = '';
  String code = '';
  String newPassword = '';
  String rePassword = '';
  bool isSending = false;
  bool isReseting = false;
  bool showVerification = false;
  bool showPassword = false;
  bool hiddenPassword = true;
  bool hiddenRePassword = true;
  final AuthService _authService = AuthService();

  void setEmail(value) {
    email = value;
    notifyListeners();
  }

  void setCode(value) {
    code = value;
    notifyListeners();
  }

  void setNewPassword(value) {
    newPassword = value;
    notifyListeners();
  }

  void setRePassword(value) {
    rePassword = value;
    notifyListeners();
  }

  Future<String?> sendCode() async {
    if (email.trim().isEmpty) return '請輸入Email';
    isSending = true;
    notifyListeners(); // 立即更新 UI
    try {
      final result = await _authService.checkEmailExists(email);
      if (!result['exists']) return result['message'];
      final error = await _authService.sendCode(email.trim());
      showVerification = true;
      notifyListeners();
      return error; // null 表示成功
    } catch (e) {
      return '發生錯誤';
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  Future<String?> verifyCode() async {
    if (code.trim().isEmpty) return '請輸入驗證碼';
    final error = await _authService.verifyCode(email, code);
    notifyListeners();
    return error; // null 表示成功，其它是錯誤訊息
  }

  bool isFilled() {
    return email.isNotEmpty && code.isNotEmpty && newPassword.isNotEmpty && rePassword.isNotEmpty;
  }

  void togglePasswordVisibility() {
    hiddenPassword = !hiddenPassword;
    notifyListeners();
  }

  void toggleRePasswordVisibility() {
    hiddenRePassword = !hiddenRePassword;
    notifyListeners();
  }

  Future<String?> resetPassword() async {
    if (!Auth.validatePassword(newPassword)) return '請輸入8至16位的英文字母及數字組合';
    if (!Auth.verifyPassword(newPassword, rePassword)) return '密碼不一致，請重新輸入';
    isReseting = true;
    notifyListeners(); // 立即更新 UI
    try {
      final error = await _authService.resetPassword(email, newPassword);
      notifyListeners();
      return error; // null 表示成功
    } catch (e) {
      return '發生錯誤';
    } finally {
      isReseting = false;
      notifyListeners();
    }
  }

  @override
  String toString() {
    return '''
      === 資料 ===
      帳號: $email
      驗證碼: $code
      新密碼: $newPassword
      重複密碼: $rePassword
      ================
      ''';
  }
}
