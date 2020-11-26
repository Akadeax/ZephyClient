import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/app/text_styles.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/utils/color_util.dart';

import 'single_channel_display_logic.dart';

class SingleChannelDisplay extends StatelessWidget {
  final BaseChannelData data;
  final SingleChannelDisplayLogic logic;
  SingleChannelDisplay(this.data) : logic = SingleChannelDisplayLogic(data);

  @override
  Widget build(BuildContext context) {
    ServerConnection _conn = Provider.of<ServerConnection>(context);

    bool isLoadingMessages = _conn.packetHandler.isPacketWaitOpen(PopulateMessagesPacket.TYPE);

    return CircleAvatar(
        backgroundColor: isLoadingMessages ? Colors.black : rndChannelIconColor,
        child: Container(
          child: FlatButton(
            shape: CircleBorder(),
            child: Text(data.name.substring(0, 2), style: AppTextStyles.channelIconStyle),
            onPressed: () => logic.pushChatDisplay(context),
            onLongPress: () => logic.pushAdminDisplay(context),
          ),
        )
    );
  }
}
