import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/screens/connection_screen.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ServerConnection>(create: (_) => ServerConnection()),
        ChangeNotifierProvider(create: (_) => ProfileData()),
      ],
      builder: (_, __) {
        return _appContent();
      },
    )
  );
}

Widget _appContent() {
  return MaterialApp(
    navigatorKey: navigatorKey,
    home: ConnectionScreen(),
    debugShowCheckedModeBanner: false,
  );
}
