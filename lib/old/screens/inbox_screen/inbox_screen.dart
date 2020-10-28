import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///D:/dev/Programming/Dart/Flutter/zephy_client/lib/models/channel_model.dart';
import 'package:zephy_client/models/role_model.dart';
import 'package:zephy_client/packet/channel/modify_channel_roles_packet.dart';
import 'package:zephy_client/screens/inbox_screen/sidebar/sidebar_channel_display.dart';
import 'package:zephy_client/services/packet_wait.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class InboxScreen extends StatefulWidget {

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  ServerConnection _conn;

  GlobalKey<NavigatorState> chatNavKey = GlobalKey<NavigatorState>();

  DisplayChannel displayChannel = DisplayChannel();

  PacketWait modifyRolesWait = PacketWait<ModifyChannelRolesPacket>(
      ModifyChannelRolesPacket.TYPE,
      (buffer) => ModifyChannelRolesPacket.fromBuffer(buffer)
  );

  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);

    modifyRolesWait.startWait(_conn, (packet) {
      ModifyChannelRolesPacketData data = packet.readPacketData();
      List<Role> roles = displayChannel.roles;
      for(Role r in roles) {
        if(r.sId == data.role) {
          displayChannel.roles.remove(r);
          break;
        }
      }
      displayChannel.notify();
    });

    return ChangeNotifierProvider<DisplayChannel>.value(
      value: displayChannel,
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SidebarChannelDisplay(chatNavKey),
            _chat(context),
          ],
        )
      ),
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
}

class DisplayChannel extends ChangeNotifier {
  BaseChannelData baseChannelData = BaseChannelData();
  List<Role> roles = List<Role>();
  void notify() {
    notifyListeners();
  }
}
