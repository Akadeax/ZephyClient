import 'package:flutter/scheduler.dart';
import 'package:zephy_client/main.dart';

void rootNavPush(String route, [Object arg]) {
  rootNav.currentState.pushNamed(route, arguments: arg);
}

void rootNavPushReplace(String route, [Object arg]) {
  rootNav.currentState.pushReplacementNamed(route, arguments: arg);
}

void rootNavPushReplaceDelayed(String route) {
  SchedulerBinding.instance.addPostFrameCallback((timeStamp) => rootNavPushReplace(route));
}