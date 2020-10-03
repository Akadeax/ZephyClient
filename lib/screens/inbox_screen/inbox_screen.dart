import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/packet/channel/modify_channel_roles_packet.dart';
import 'file:///D:/dev/Programming/Dart/Flutter/zephy_client/lib/screens/inbox_screen/sidebar/sidebar_channel_display.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class InboxScreen extends StatefulWidget {

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  ServerConnection _conn;

  GlobalKey<NavigatorState> chatNavKey = GlobalKey<NavigatorState>();

  Future<void> waitForRolesMod() async {
    var packet = await modifyFuture;

    var data = packet.readPacketData();
    switch(data.action) {
      // TODO: reload accessible channels?
      case ModifyChannelRolesAction.ADD:
        break;
      // TODO: reload accessible channels, maybe kick out of current one?
      case ModifyChannelRolesAction.REMOVE:
        break;
    }
  }

  Future<ModifyChannelRolesPacket> modifyFuture;

  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);

    if(modifyFuture == null) {
      modifyFuture = _conn.packetHandler.waitForPacket(
          ModifyChannelRolesPacket.TYPE,
              (buffer) => ModifyChannelRolesPacket.fromBuffer(buffer)
      );
      waitForRolesMod();
    }

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