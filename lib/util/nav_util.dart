import 'package:flutter/material.dart';

void navPush(BuildContext context, String route) {
  Navigator.of(context).pushReplacementNamed(route);
}

PageRouteBuilder pageRouteBuilder(Widget page) {
  return PageRouteBuilder(
    maintainState: false,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (_, anim, __, child) {
      return FadeTransition(
        opacity: anim,
        child: child,
      );
    },
    pageBuilder: (_, __, ___) {
      return page;
    },
  );
}