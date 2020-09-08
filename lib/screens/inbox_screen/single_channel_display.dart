import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';
import 'package:zephy_client/services/style_presets.dart';

import 'chat/chat_display.dart';

class SingleChannelDisplay extends StatelessWidget {
  final GlobalKey<NavigatorState> chatNav;
  final BaseChannelData data;

  SingleChannelDisplay(this.chatNav, this.data);


  @override
  Widget build(BuildContext context) {
    ServerConnection _conn = Provider.of<ServerConnection>(context);
    bool isLoadingMessages = _conn.packetHandler.isPacketWaitOpen(PopulateMessagesPacket.TYPE);

    return CircleAvatar(
        backgroundColor: isLoadingMessages ? Colors.black : StylePresets.channelIconColor,
        child: Container(
          child: FlatButton(
              shape: CircleBorder(),
              child: Text(data.name.substring(0, 2), style: StylePresets.channelIconStyle),
              onPressed: () {
                if(isLoadingMessages) return;

                chatNav.currentState.pushReplacement(
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) {
                          return ChatDisplay(forChannel: data);
                        }
                    )
                );
              }
          ),
        )
    );
  }
}
