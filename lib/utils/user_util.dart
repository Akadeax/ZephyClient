import 'package:zephy_client/models/user_model.dart';

const String ADMIN_ROLE_NAME = "admin";

bool isAdmin(PopulatedUser user) {
  return user.roles.any((el) => el.name == ADMIN_ROLE_NAME);
}