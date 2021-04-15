import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/routes.dart';
import 'package:zephy_client/theme/dark.dart';

void main() {
  runApp(ZephyApp());
}

class ZephyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ServerConnection>(create: (_) => ServerConnection()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Zephy",
        theme: ZephyDark.theme,
        initialRoute: "/connect",
        routes: routes,
      ),
    );
  }
}
