import 'package:flutter/material.dart';
import 'package:zephy_client/screens/connection_screen/connection_screen.dart';
import 'package:zephy_client/screens/fatal_error_screen/fatal_error_screen.dart';
import 'package:zephy_client/screens/login_screen/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  "/": (BuildContext context) => ConnectionScreen(),
  "/login": (BuildContext context) => LoginScreen(),

  "/fatal": (BuildContext context) => FatalErrorScreen(),
};


Route<dynamic> routeGenerator(RouteSettings settings) {
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
