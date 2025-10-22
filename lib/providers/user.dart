import 'package:amir_api/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;

  void setUser(UserModel model) {
    _userModel = model;
    notifyListeners();
  }

  UserModel? getUser() => _userModel;
}
