import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/screens/inbox_screen/sidebar_channel_display.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class InboxScreen extends StatefulWidget {

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  ServerConnection _conn;

  GlobalKey<NavigatorState> chatNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);

    return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SidebarChannelDisplay(chatNavKey),
            _chat(context),
          ],
        )
    );
  }

  Widget _chat(BuildContext context) {
    return Expanded(
      child: Navigator(
        key: chatNavKey,
        initialRoute: null,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (_) => Container()
          );
        },
      ),
    );
  }


  @override
  void dispose() {
    _conn.closeConnection();
    super.dispose();
  }
}