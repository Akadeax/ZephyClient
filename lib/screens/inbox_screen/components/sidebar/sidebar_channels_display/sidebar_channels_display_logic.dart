import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/prov/current_login_user.dart';
import 'package:zephy_client/screens/inbox_screen/components/sidebar/sidebar_channels_display/sidebar_channels_display.dart';

import '../single_channel_display/single_channel_display.dart';

class SidebarChannelsDisplayAppData {
  static const EdgeInsets listViewPadding = const EdgeInsets.symmetric(vertical: 30);
  static const EdgeInsets listViewItemsPadding = const EdgeInsets.symmetric(vertical: 10);

  static const double sidebarWidth = 80;
}

class SidebarChannelsDisplayLogic {
  SidebarChannelsDisplayState display;
  SidebarChannelsDisplayLogic(this.display);

  ServerConnection conn;
  CurrentLoginUser currentLoginUser;

  Widget streamBuilder(BuildContext context) {
    if(conn == null) conn = Provider.of<ServerConnection>(context);
    if(currentLoginUser == null) currentLoginUser = Provider.of<CurrentLoginUser>(context);

    // POSSIBLE ERROR: Reload on rebuild, dk yet
    sendChannelInfoRequest();

    return StreamProvider<AccessibleChannelsInfoPacket>(
      create: (_) => currentLoginUser.accessibleChannelsStream(conn),
      builder: _consumerBuilder,
    );
  }

  Widget channelsListViewItemBuilder(int i, AccessibleChannelsInfoPacketData data) {
    return Padding(
        padding: SidebarChannelsDisplayAppData.listViewItemsPadding,
        child: SingleChannelDisplay(data.accessibleChannelsData[i])
    );
  }

  void sendChannelInfoRequest() {
    var packet = AccessibleChannelsInfoPacket(AccessibleChannelsInfoPacketData(
      forUser: currentLoginUser.user.sId,
    ));

     conn.sendPacket(packet);
  }

  Widget _consumerBuilder(BuildContext context, Widget widget) {
    return Consumer<AccessibleChannelsInfoPacket>(
      builder: (context, val, _) {
        if(val == null) return display.waitingDisplay();

        var data = val.readPacketData();
        return display.sidebarChannelsDisplay(data);
      },
    );
  }
}