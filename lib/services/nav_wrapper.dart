import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zephy_client/main.dart';

BuildContext get rootNavContext => navigatorKey.currentState.context;

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
        transitionsBuilder: (context, anim, secAnim, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        },
        pageBuilder: (context, anim, secAnim) {
          return page;
        },
      )
  );
}
