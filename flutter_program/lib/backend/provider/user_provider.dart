import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserInfo? _user;

  UserInfo? get user => _user;

  // 加入兩個安全存取器
  int? get userID => _user?.id;
  // String? get role => _user?.role;

  // 判斷是否為訪客
  bool get isGuest => userID == -1;

  void setUserInfo(UserInfo user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void updateUserName(String newName) {
    if (_user != null) {
      _user = _user!.copyWith(name: newName);
      notifyListeners();
    }
  }

  List<UserReport> get reports => _user?.reports ?? [];
}
