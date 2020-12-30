import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/role_model.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'file:///D:/dev/Programming/Dart/Flutter/zephy_client/lib/packet/role/fetch_roles_packet.dart';
import 'package:zephy_client/packet/channel/modify_channel_packet.dart';
import 'package:zephy_client/packet/packet_wait.dart';
import 'package:zephy_client/prov/current_display_channel.dart';
import 'package:zephy_client/screens/inbox_screen/components/channel_admin_display/components/single_admin_role_display.dart';

import 'channel_admin_display.dart';

class ChannelAdminDisplayLogic {
  ChannelAdminDisplayState display;
  ChannelAdminDisplayLogic(this.display);

  ServerConnection conn;
  CurrentDisplayChannel currentDisplayChannel;

  TextEditingController nameInputController = TextEditingController();

  var fetchRolesWait = PacketWait<FetchRolesPacket>(
      FetchRolesPacket.TYPE,
      (buffer) => FetchRolesPacket.fromBuffer(buffer)
  );
  var modifyRolesWait = PacketWait<ModifyChannelPacket>(
      ModifyChannelPacket.TYPE,
      (buffer) => ModifyChannelPacket.fromBuffer(buffer)
  );

  Widget rolesDisplay(BuildContext context) {
    return Consumer<CurrentDisplayChannel>(
      builder: (ctx, __, ___) {
        if(currentDisplayChannel != null && currentDisplayChannel.baseChannelData != null) {
          // add into Scheduler because when this is set, this element is still
          // building (i.e. in builder)!
          // without this, setting the text tells the framework to reload while it's
          // already reloading -> err
          SchedulerBinding.instance.addPostFrameCallback((_) {
            nameInputController.text = currentDisplayChannel.baseChannelData.name;
          });
        }

        return _rolesListView(ctx);
      },
    );
  }

  Widget _rolesListView(BuildContext context) {
    if(currentDisplayChannel == null) {
      currentDisplayChannel = Provider.of<CurrentDisplayChannel>(context, listen: false);
      conn = Provider.of<ServerConnection>(context, listen: false);

      _fetchRoles();

      fetchRolesWait.startWait(
          conn,
          (packet) => _onFetchChannelRolesRecv(packet.readPacketData())
      );

      modifyRolesWait.startWait(
        conn,
        (packet) => _onModifyChannelRolesRecv(packet.readPacketData())
      );
    }

    if(currentDisplayChannel.roles.isEmpty) return Center(child: Text("loading..."));

    return ListView.builder(
      itemCount: currentDisplayChannel.roles.length,
      itemBuilder: (ctx, i) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: SingleAdminRoleDisplay(currentDisplayChannel.roles[i], this),
        );
      },
    );
  }

  /// send request to fetch all roles for currentDisplayChannel
  void _fetchRoles() {
    var packet = FetchRolesPacket(FetchRolesPacketData(
        forChannel: currentDisplayChannel.baseChannelData.sId
    ));
    conn.sendPacket(packet);
  }

  void _onFetchChannelRolesRecv(FetchRolesPacketData data) {
    if(data.forChannel != currentDisplayChannel.baseChannelData.sId) return;

    currentDisplayChannel.roles = data.roles;
    currentDisplayChannel.notify();
  }

  void _onModifyChannelRolesRecv(ModifyChannelPacketData data) {
    if(data.action == ModifyChannelAction.ADD_ROLE || data.action == ModifyChannelAction.REMOVE_ROLE) {
      _fetchRoles();
    } else if(data.action == ModifyChannelAction.UPDATE_NAME) {
      currentDisplayChannel.baseChannelData.name = data.data;
    } else if(data.action == ModifyChannelAction.UPDATE_DESC) {
      currentDisplayChannel.baseChannelData.description = data.data;
    } else if(data.action == ModifyChannelAction.DELETE) {

    }

    currentDisplayChannel.notify();
  }

  void onDeleteRoleButton(Role role) {
    var packet = ModifyChannelPacket(ModifyChannelPacketData(
      channel: currentDisplayChannel.baseChannelData.sId,
      action: ModifyChannelAction.REMOVE_ROLE,
      data: role.sId
    ));

    conn.sendPacket(packet);
  }

  void onChangeNameButton() {
    var packet = ModifyChannelPacket(ModifyChannelPacketData(
        channel: currentDisplayChannel.baseChannelData.sId,
        action: ModifyChannelAction.UPDATE_NAME,
        data: nameInputController.text
    ));

    conn.sendPacket(packet);
  }


  void dispose() {
    fetchRolesWait.dispose();
    modifyRolesWait.dispose();
  }
}