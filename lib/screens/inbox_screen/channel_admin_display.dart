import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/role_model.dart';
import 'package:zephy_client/packet/channel/fetch_channel_roles_packet.dart';
import 'package:zephy_client/packet/channel/modify_channel_roles_packet.dart';
import 'package:zephy_client/screens/inbox_screen/inbox_screen.dart';
import 'package:zephy_client/services/packet_wait.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class ChannelAdminDisplay extends StatefulWidget {

  @override
  _ChannelAdminDisplayState createState() => _ChannelAdminDisplayState();
}

class _ChannelAdminDisplayState extends State<ChannelAdminDisplay> {

  var fetchRolesWait = PacketWait<FetchChannelRolesPacket>(
      FetchChannelRolesPacket.TYPE,
      (buffer) => FetchChannelRolesPacket.fromBuffer(buffer),
  );

  ServerConnection _conn;
  DisplayChannel _displayChannel;

  @override
  void initState() {
    _conn = Provider.of<ServerConnection>(context, listen: false);
    _displayChannel = Provider.of<DisplayChannel>(context, listen: false);

    var packet = FetchChannelRolesPacket(FetchChannelRolesPacketData(
      forChannel: _displayChannel.baseChannelData.sId,
    ));
    _conn.sendPacket(packet);

    fetchRolesWait.startWait(_conn, (packet) {
      FetchChannelRolesPacketData data = packet.readPacketData();
      _displayChannel.roles = data.roles;
      _displayChannel.notify();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);
    _displayChannel = Provider.of<DisplayChannel>(context);

    return ListView.builder(
      itemCount: _displayChannel.roles.length,
      itemBuilder: (builderCtx, index) {
        return singleRoleAdminDisplay(_displayChannel.roles[index]);
      },
    );
  }

  Widget singleRoleAdminDisplay(Role role) {

    return Row(
      children: [
        Text(role.name),
        FlatButton(
          child: Text("delete"),
          color: Colors.blue,
          onPressed: () {
            var packet = ModifyChannelRolesPacket(ModifyChannelRolesPacketData(
              action: ModifyChannelRolesAction.REMOVE,
              channel: _displayChannel.baseChannelData.sId,
              role: role.sId,
            ));
            _conn.sendPacket(packet);
          },
        ),
      ],
    );
  }
}
