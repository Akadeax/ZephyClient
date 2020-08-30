import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zephy_client/main.dart';

BuildContext get rootNavContext => navigatorKey.currentState.context;

pushNextFrame(Widget page) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(
        navigatorKey.currentState.context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
        )
    );
  });
}