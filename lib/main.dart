import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/prov/current_login_user.dart';
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
      _currentLoginUserProvider(),
    ],
    child: child,
  );
}

Widget _connProvider() => Provider<ServerConnection>(create: (_) => ServerConnection());
Widget _currentLoginUserProvider() => ChangeNotifierProvider<CurrentLoginUser>(create: (_) => CurrentLoginUser());

Widget _content() {
  return ConnectionScreen();
}
