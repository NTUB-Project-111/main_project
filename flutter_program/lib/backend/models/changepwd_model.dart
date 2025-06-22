import 'package:drw/backend/services/user_service.dart';
import 'package:flutter/material.dart';

class ChangePwd extends ChangeNotifier {
  String pwd = '';
  String newPwd = '';
  String rePwd = '';

  bool hiddenPassword = true;
  bool hiddenNewPassword = true;
  bool hiddenRePassword = true;

  final UserService _userService = UserService();

  void setPwd(value) {
    pwd = value;
    notifyListeners();
  }

  void setNewPwd(value) {
    newPwd = value;
    notifyListeners();
  }

  void setRePwd(value) {
    rePwd = value;
    notifyListeners();
  }

  void togglePwdVisibility() {
    hiddenPassword = !hiddenPassword;
    notifyListeners();
  }

  void toggleNewPwdVisibility() {
    hiddenNewPassword = !hiddenNewPassword;
    notifyListeners();
  }

  void toggleRePwdVisibility() {
    hiddenRePassword = !hiddenRePassword;
    notifyListeners();
  }

  bool isFilled() {
    return pwd.isNotEmpty && newPwd.isNotEmpty && rePwd.isNotEmpty;
  }

  Future<String?> verifyPassword(String id) async {
    String? result;
    try {
      result = await _userService.verifyPassword(id, pwd);
    } catch (e) {
      result = '發生錯誤';
    }
    return result;
  }

  Future<String?> updatePassword(String id) async {
    String? result;
    try {
      result = await _userService.updatePassword(id, newPwd);
    } catch (e) {
      result = '發生錯誤';
    }
    return result;
  }

  @override
  String toString() {
    return '''
    ===使用者輸入===
    原密碼:$pwd
    新密碼:$newPwd
    確定密碼:$rePwd
    ===============
    ''';
  }
}
