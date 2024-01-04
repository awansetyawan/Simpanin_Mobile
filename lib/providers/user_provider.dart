import 'package:flutter/material.dart';
import 'package:simpanin/models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    address: '',
    id: '',
    email: '',
    name: '',
    phone: '',
    role: 'user',
  );

  UserModel get user => _user;

  void setAuth(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
