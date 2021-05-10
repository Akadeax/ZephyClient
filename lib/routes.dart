import 'package:flutter/material.dart';
import 'package:zephy_client/screens/connection_screen/connection_screen.dart';
import 'package:zephy_client/screens/fatal_error_screen/fatal_error_screen.dart';
import 'package:zephy_client/screens/inbox_screen/inbox_screen.dart';
import 'package:zephy_client/screens/login_screen/login_screen.dart';

const String initialRoute = "/connect";
final Map<String, WidgetBuilder> routes = {
  "/connect": (BuildContext context) => ConnectionScreen(),
  "/login": (BuildContext context) => LoginScreen(),
  "/inbox": (BuildContext context) => InboxScreen(),

  "/fatal": (BuildContext context) => FatalErrorScreen(),
};


Route<dynamic> routeGenerator(RouteSettings param) {
  RouteSettings settings = param;
  if(settings.name == "/") settings = param.copyWith(name: initialRoute);

  if(routes.containsKey(settings.name)) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (ctx, __, ___) => routes[settings.name](ctx),

      transitionsBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
  } else {
    throw ArgumentError("Route '${settings.name}' does not exist");
  }
}
