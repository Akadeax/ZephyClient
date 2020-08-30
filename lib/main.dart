import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/screens/connection_screen.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  runApp(
    _profileDataProvider(),
  );
}

Widget _profileDataProvider() {
  return ChangeNotifierProvider<ProfileData>(
    create: (context) => ProfileData(),
    child: _serverConnectionProvider(),
  );
}

Widget _serverConnectionProvider() {
  return Provider<ServerConnection>.value(
    value: ServerConnection(),
    child: _appContent(),
  );
}


Widget _appContent() {
  return MaterialApp(
    navigatorKey: navigatorKey,
    home: ConnectionScreen(),
    debugShowCheckedModeBanner: false,
  );
}
