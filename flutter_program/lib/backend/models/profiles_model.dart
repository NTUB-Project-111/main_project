import 'package:drw/backend/services/user_service.dart';
import 'package:flutter/material.dart';

class Profiles extends ChangeNotifier {
  String name = '';
  final UserService _user = UserService();

  void setName(value) {
    name = value;
    notifyListeners();
  }

  bool isFilled() {
    return name.isNotEmpty;
  }

  Future<bool> updateUserName(String id,String newName) async {
    final success = await _user.updateUserName(id, newName);
    if (success) {
      name = newName;
      notifyListeners(); // 更新 UI
    }
    return success;
  }
}
