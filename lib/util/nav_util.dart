import 'package:flutter/scheduler.dart';
import 'package:zephy_client/main.dart';

void rootNavPush(String route) {
  rootNav.currentState.pushReplacementNamed(route);
}

void rootNavPushDelayed(String route) {
  SchedulerBinding.instance.addPostFrameCallback((timeStamp) => rootNavPush(route));
}