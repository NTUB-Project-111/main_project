import 'package:drw/backend/models/report.dart';
import 'package:drw/backend/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserInfo? _user;

  UserInfo? get user => _user;

  void setUserInfo(UserInfo user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  List<UserReport> get reports => _user?.reports ?? [];
}
