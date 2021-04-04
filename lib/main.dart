import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/screens/connection_screen/connection_screen.dart';

GlobalKey<NavigatorState> mainNavKey = GlobalKey();

main() {
  runApp(
    _providers(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: mainNavKey,
        home: _content(),
      ),
    ),
  );
}

Widget _providers({@required Widget child}) {
  return MultiProvider(
    providers: [
      _connProvider(),
    ],
    child: child,
  );
}

Widget _connProvider() => Provider<ServerConnection>(create: (_) => ServerConnection());

Widget _content() {
  return ConnectionScreen();
}