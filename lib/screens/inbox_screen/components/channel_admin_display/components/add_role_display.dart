import 'package:flutter/material.dart';
import 'package:zephy_client/app/color_sets.dart';
import 'package:zephy_client/models/role_model.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/packet/channel/modify_channel_packet.dart';
import 'package:zephy_client/packet/packet_wait.dart';
import 'package:zephy_client/packet/role/fetch_roles_packet.dart';
import 'package:zephy_client/screens/inbox_screen/components/channel_admin_display/channel_admin_display_logic.dart';

class AddRoleDisplay extends StatefulWidget {
  final ChannelAdminDisplayLogic logic;
  AddRoleDisplay(this.logic);

  @override
  _AddRoleDisplayState createState() => _AddRoleDisplayState();
}

class _AddRoleDisplayState extends State<AddRoleDisplay> {
  var fetchAllRolesWait = PacketWait<FetchRolesPacket>(
      FetchRolesPacket.TYPE,
      (buffer) => FetchRolesPacket.fromBuffer(buffer)
  );
  
  List<Role> allRoles = List<Role>();


  @override
  void initState() {
    fetchAllRolesWait.startWait(widget.logic.conn, (packet) {
      var data = packet.readPacketData();
      if(data.forChannel != "") return;

      setState(() {
        allRoles = packet.readPacketData().roles;
      });
    });

    // no arg for data fetches all roles
    widget.logic.conn.sendPacket(
        FetchRolesPacket(FetchRolesPacketData(forChannel: ""))
    );

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    if(allRoles.isEmpty) {
      return Container();
    }

    return PopupMenuButton<Role>(
      onSelected: (Role result) {

        widget.logic.conn.sendPacket(
          ModifyChannelPacket(ModifyChannelPacketData(
            channel: widget.logic.currentDisplayChannel.baseChannelData.sId.toString(),
            action: ModifyChannelAction.ADD_ROLE,
            data: result.sId
          ))
        );

      },
      itemBuilder: (ctx) {
        var roleAddDisplays = List<PopupMenuEntry<Role>>();

        for(Role role in allRoles) {
          bool idInCurrentChannel = false;
          for(Role channelRole in widget.logic.currentDisplayChannel.roles) {
            if(channelRole.sId == role.sId) idInCurrentChannel = true;
          }
          if(idInCurrentChannel) continue;

          roleAddDisplays.add(
            PopupMenuItem<Role>(
              value: role,
              child: Text(role.name),
            )
          );
        }

        return roleAddDisplays;
      },
    );
  }

  @override
  void dispose() {
    fetchAllRolesWait.dispose();
    super.dispose();
  }
}