import 'package:flutter/material.dart';
import 'package:zephy_client/models/user.dart';

class ProfileHandler extends ChangeNotifier {
  User user;
  void notify() => notifyListeners();
}