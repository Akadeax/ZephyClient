import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zephy_client/main.dart';

BuildContext get rootNavContext => mainNavKey.currentState.context;

pushNextFrame(Widget page, BuildContext context) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    push(page, context);
  });
}

push(Widget page, BuildContext context) {
  pushOnNav(
      page,
      Navigator.of(context)
  );
}

pushOnNav(Widget page, NavigatorState nav) {
  nav.pushReplacement(
      PageRouteBuilder(
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
      )
  );
}
