import 'package:flutter/scheduler.dart';
import 'package:zephy_client/main.dart';

void rootNavPush(String route, [Object arg]) {
  rootNav.currentState.pushReplacementNamed(route, arguments: arg);
}

void rootNavPushDelayed(String route) {
  SchedulerBinding.instance.addPostFrameCallback((timeStamp) => rootNavPush(route));
}