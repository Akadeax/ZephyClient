bool isValidEmail(String email) {
  String regex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  return RegExp(regex).hasMatch(email);
}

bool isValidPassword(String password) {
  String regex = r"\w";
  return RegExp(regex).hasMatch(password);
}