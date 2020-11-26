import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/packet/message/message_send_packet.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/packet/packet_wait.dart';
import 'package:zephy_client/prov/current_display_channel.dart';
import 'package:zephy_client/prov/current_login_user.dart';
import 'package:zephy_client/screens/inbox_screen/components/chat/single_message_display.dart';

class ChatDisplayLogic {
  bool disposed = false;

  int nextPageToLoad = 0;

  PacketWait messageLoadWait = PacketWait<PopulateMessagesPacket>(
    PopulateMessagesPacket.TYPE,
    (buffer) => PopulateMessagesPacket.fromBuffer(buffer)
  );

  PacketWait messageReceiveWait = PacketWait<MessageSendPacket>(
    MessageSendPacket.TYPE,
      (buffer) => MessageSendPacket.fromBuffer(buffer)
  );

  ServerConnection conn;
  CurrentLoginUser user;
  CurrentDisplayChannel channel;
  void init(BuildContext context) {
    bool isFirstInit = conn == null;

    conn = Provider.of<ServerConnection>(context, listen: false);
    user = Provider.of<CurrentLoginUser>(context, listen: false);
    channel = Provider.of<CurrentDisplayChannel>(context, listen: false);

    if(isFirstInit) loadNextPage();

    startWaits(context);

    scrollController.addListener(() {
      bool isLoadingMessages = conn.packetHandler.isPacketWaitOpen(PopulateMessagesPacket.TYPE);
      if(scrollControllerIsAtEnd && !isLoadingMessages) {
        loadNextPage();
      }
    });
  }

  void startWaits(BuildContext context) {
    messageLoadWait.startWait(conn, (packet) {
      PopulateMessagesPacketData data = packet.readPacketData();
      onMessageLoadReceived(data, context);
    });

    messageReceiveWait.startWait(conn, (packet) {
      MessageSendPacketData data = packet.readPacketData();
      onMessageSendReceived(data, context);
    });
  }

  void onMessageLoadReceived(PopulateMessagesPacketData data, BuildContext context) {
    if(disposed) return;
    CurrentDisplayChannel channel = Provider.of<CurrentDisplayChannel>(context, listen: false);

    channel.messages.addAll(data.populatedMessages);
    channel.notify();
  }

  void onMessageSendReceived(MessageSendPacketData data, BuildContext context) {
    if(disposed) return;

    CurrentDisplayChannel channel = Provider.of<CurrentDisplayChannel>(context, listen: false);

    channel.messages.insert(0, data.returnMessage);
    channel.notify();
  }

  ScrollController scrollController = ScrollController();

  Widget messageItemBuilder(BuildContext context, int index) {
    return SingleMessageDisplay(channel.messages[index]);
  }

  void loadNextPage() {
    if(conn == null) return;
    PopulateMessagesPacket packet = PopulateMessagesPacket(PopulateMessagesPacketData(
        forChannel: channel.baseChannelData.sId,
        user: user.user.sId,
        page: nextPageToLoad++
    ));
    conn.sendPacket(packet);
  }

  bool get scrollControllerIsAtEnd => scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange;


  void dispose() {
    disposed = true;
    messageLoadWait.dispose();
    messageReceiveWait.dispose();
  }
}
