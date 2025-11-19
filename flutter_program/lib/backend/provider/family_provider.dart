import 'package:drw/backend/models/family.dart';
import 'package:flutter/material.dart';

class FamilyProvider extends ChangeNotifier {
  List<UserFamily> _members = [];

  List<UserFamily> get members => _members;

  void setMembers(List<UserFamily> members) {
    _members = members;
    notifyListeners();
  }

  void setMember(UserFamily member,int i) {
    _members[i] = member;
    notifyListeners();
  }

  void addMember(UserFamily member) {
    _members.add(member);
    notifyListeners();
  }

  void addReminds(List<UserFamily> members) {
    _members.addAll(members);
    notifyListeners();
  }

  void removeRemind(int memberId) {
    _members.removeWhere((m) => m.userId == memberId);
    notifyListeners();
  }
}
