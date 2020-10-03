import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/screens/inbox_screen/channel_admin_display.dart';
import 'package:zephy_client/services/nav_wrapper.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';
import 'package:zephy_client/services/style_presets.dart';
import 'package:zephy_client/services/user_util.dart';

import '../chat/chat_display.dart';

class SingleChannelDisplay extends StatelessWidget {
  final GlobalKey<NavigatorState> chatNav;
  final BaseChannelData data;

  SingleChannelDisplay(this.chatNav, this.data);


  @override
  Widget build(BuildContext context) {
    ServerConnection _conn = Provider.of<ServerConnection>(context);
    ProfileData profData = Provider.of<ProfileData>(context);
    bool isLoadingMessages = _conn.packetHandler.isPacketWaitOpen(PopulateMessagesPacket.TYPE);

    return CircleAvatar(
        backgroundColor: isLoadingMessages ? Colors.black : StylePresets.channelIconColor,
        child: Container(
          child: FlatButton(
            shape: CircleBorder(),
            child: Text(data.name.substring(0, 2), style: StylePresets.channelIconStyle),
            onPressed: () {
              if(isLoadingMessages) return;

              pushOnNav(ChatDisplay(forChannel: data), chatNav.currentState);
            },
            onLongPress: () {
              if(!isAdmin(profData.loggedInUser)) return;

              print("PUSH");
              pushOnNav(ChannelAdminDisplay(data), chatNav.currentState);
            },
          ),
        )
    );
  }
}
