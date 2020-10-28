import 'package:flutter/material.dart';
import 'package:zephy_client/models/user_model.dart';

class CurrentLoginUser extends ChangeNotifier {
  PopulatedUser _user;

  PopulatedUser get user => _user;

  void setUser(PopulatedUser newUser, [bool shouldNotifyListeners = true]) {
    _user = newUser;
    if(shouldNotifyListeners) notifyListeners();
  }
}