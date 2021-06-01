import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/components/error_snack_bar.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/models/message.dart';
import 'package:zephy_client/networking/packet/message/populate_messages_request_packet.dart';
import 'package:zephy_client/networking/packet/message/populate_messages_response_packet.dart';
import 'package:zephy_client/networking/packet/message/send_message_response_packet.dart';
import 'package:zephy_client/networking/packet/packet_wait.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/util/nav_util.dart';

class CurrentChannel extends ChangeNotifier {
  static const int PAGE_SIZE = 25;
  static const String FETCHED_MESSAGES_BAD_REQUEST = "Fetched messages were bad request";

  BaseChannelData channel;
  List<PopulatedMessage> fetchedMessages = [];
  int messagePage = 0;

  var _fetchReceiveWait = PacketWait<PopulateMessagesResponsePacket>(
      PopulateMessagesResponsePacket.TYPE,
      (buffer) => PopulateMessagesResponsePacket.fromBuffer(buffer)
  );

  var _messageReceiveWait = PacketWait<SendMessageResponsePacket>(
      SendMessageResponsePacket.TYPE,
      (buffer) => SendMessageResponsePacket.fromBuffer(buffer)
  );


  BuildContext channelContext;
  CurrentChannel(this.channel, BuildContext context) {
    channelContext = context;
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    _fetchReceiveWait.startWait(
        conn,
        (packet) => _onFetchedMessagesReceived(packet.readPacketData())
    );
    _messageReceiveWait.startWait(
        conn,
        (packet) => _onNewMessageReceived(packet.readPacketData())
    );
  }

  void _onFetchedMessagesReceived(PopulateMessagesResponsePacketData data) {
    if(data.httpStatus == HttpStatus.ok && data.page == messagePage) {
      fetchedMessages.addAll(data.fetchedMessages);
      messagePage++;
      notifyListeners();
    } else {
      rootNavPushReplace("/fatal", FETCHED_MESSAGES_BAD_REQUEST);
    }
  }

  _onNewMessageReceived(SendMessageResponsePacketData data) {
    // if the received message is not in the currently loaded
    // channel, the user will get a notification instead
    if(data.message?.channel != channel.sId) return;

    if(data.httpStatus != HttpStatus.ok) {
      showErrorSnackBar("Couldn't send message!", channelContext);
      return;
    }

    fetchedMessages.insert(0, data.message);
    notifyListeners();
  }

  void fetchNextPage(BuildContext context) {
    var conn = Provider.of<ServerConnection>(context, listen: false);
    var request = PopulateMessagesRequestPacket(PopulateMessagesRequestPacketData(
      forChannel: channel.sId,
      page: messagePage,
    ));
    conn.sendPacket(request);
  }

  @override
  void dispose() {
    _fetchReceiveWait.dispose();
    _messageReceiveWait.dispose();
    super.dispose();
  }
}