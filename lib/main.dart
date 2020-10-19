import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/packet/packet_handler.dart';
import 'package:zephy_client/screens/connection_screen/connection_screen.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

ServerConnection conn = ServerConnection();
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ServerConnection>(create: (_) => conn),
        ChangeNotifierProvider(create: (_) => ProfileData()),
        ChangeNotifierProvider<PacketHandler>.value(value: conn.packetHandler),
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
