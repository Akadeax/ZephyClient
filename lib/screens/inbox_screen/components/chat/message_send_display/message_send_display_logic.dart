import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/packet/message/message_send_packet.dart';
import 'package:zephy_client/prov/current_display_channel.dart';

import 'messsage_send_display.dart';

class MessageSendDisplayLogic {
  MessageSendDisplayState display;
  MessageSendDisplayLogic(this.display);

  TextEditingController controller = TextEditingController();
  FocusNode controllerNode = FocusNode();

  void sendMessage(BuildContext context) {
    CurrentDisplayChannel channel = Provider.of<CurrentDisplayChannel>(context, listen: false);
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);

    MessageSendPacket packet = MessageSendPacket(MessageSendPacketData(
      message: controller.text,
      channel: channel.baseChannelData.sId
    ));

    conn.sendPacket(packet);
    controller.clear();
    controllerNode.requestFocus();
  }
}