import 'package:flutter/material.dart';
import 'package:zephy_client/screens/chat_screen/chat_screen.dart';
import 'package:zephy_client/screens/connection_screen/connection_screen.dart';
import 'package:zephy_client/screens/fatal_error_screen/fatal_error_screen.dart';
import 'screens/inbox_screen/chats_list/inbox_screen.dart';
import 'package:zephy_client/screens/login_screen/login_screen.dart';

typedef RouteBuilder(BuildContext context, [Object param]);

const String initialRoute = "/connect";
final Map<String, RouteBuilder> routes = {
  "/connect": (BuildContext context, [Object param]) => ConnectionScreen(),
  "/login": (BuildContext context, [Object param]) => LoginScreen(),
  "/inbox": (BuildContext context, [Object param]) => InboxScreen(),
  "/chat": (BuildContext context, [Object param]) => ChatScreen(param),

  "/fatal": (BuildContext context, [Object param]) => FatalErrorScreen(param),
};


Route<dynamic> routeGenerator(RouteSettings param) {
  RouteSettings settings = param;
  if(settings.name == "/") settings = param.copyWith(name: initialRoute);

  if(routes.containsKey(settings.name)) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (ctx, __, ___) => routes[settings.name](ctx, param.arguments),

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
