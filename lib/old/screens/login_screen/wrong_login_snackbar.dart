import 'package:flutter/material.dart';

SnackBar wrongLoginSnackBar() {
  return SnackBar(
    content: Text("Invalid login data!"),
    backgroundColor: Colors.redAccent,
    duration: const Duration(seconds: 3),
  );
}

