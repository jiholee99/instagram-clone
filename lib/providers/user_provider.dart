import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    //print("refresh user started");
    User updatedUser = await AuthMethods().getUserDetials();
    _user = updatedUser;
    notifyListeners();
  }

  void printStatement() {
    print("this is user provider print statement");
  }
}
