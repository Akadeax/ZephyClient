import 'package:flutter/foundation.dart';
import 'package:zephy_client/models/user_model.dart';

class ProfileData with ChangeNotifier {
  PopulatedUser _loggedInUser;

  PopulatedUser get loggedInUser
      => _loggedInUser;

  set loggedInUser(PopulatedUser newUser) {
    _loggedInUser = newUser;
    notifyListeners();
  }
}
