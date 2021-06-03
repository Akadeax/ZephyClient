import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/components/error_snack_bar.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/models/message.dart';
import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/message/populate_messages_request_packet.dart';
import 'package:zephy_client/networking/packet/message/populate_messages_response_packet.dart';
import 'package:zephy_client/networking/packet/message/send_message_response_packet.dart';
import 'package:zephy_client/networking/packet/packet_wait.dart';
import 'package:zephy_client/networking/packet/user/fetch_members_request_packet.dart';
import 'package:zephy_client/networking/packet/user/fetch_members_response_packet.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/util/nav_util.dart';

class CurrentChannel extends ChangeNotifier {
  static const int PAGE_SIZE = 25;
  static const String FETCHED_CHANNEL_BAD_REQUEST = "Fetched Channel was bad request.";

  BaseChannelData channel;
  List<PopulatedMessage> fetchedMessages = [];
  List<User> members;
  int messagePage = -1;

  var _fetchMessagesWait = PacketWait<PopulateMessagesResponsePacket>(
      PopulateMessagesResponsePacket.TYPE,
      (buffer) => PopulateMessagesResponsePacket.fromBuffer(buffer)
  );

  var _fetchMembersWait = PacketWait<FetchMembersResponsePacket>(
      FetchMembersResponsePacket.TYPE,
      (buffer) => FetchMembersResponsePacket.fromBuffer(buffer)
  );

  var _newMessageWait = PacketWait<SendMessageResponsePacket>(
      SendMessageResponsePacket.TYPE,
      (buffer) => SendMessageResponsePacket.fromBuffer(buffer)
  );

  BuildContext channelContext;

  CurrentChannel(this.channel, BuildContext context) {
    channelContext = context;
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    _fetchMessagesWait.startWait(
        conn,
        (packet) => _onFetchedMessagesReceived(packet.readPacketData())
    );
    _fetchMembersWait.startWait(
        conn,
        (packet) => _onFetchedMembersReceived(packet.readPacketData())
    );
    _newMessageWait.startWait(
        conn,
        (packet) => _onNewMessageReceived(packet.readPacketData())
    );
  }

  void _onFetchedMessagesReceived(PopulateMessagesResponsePacketData data) {
    if(data.httpStatus == HttpStatus.ok) {
      fetchedMessages.addAll(data.fetchedMessages);
      messagePage = data.page;
      notifyListeners();
    } else {
      rootNavPushReplace("/fatal", FETCHED_CHANNEL_BAD_REQUEST);
    }
  }

  void _onFetchedMembersReceived(FetchMembersResponsePacketData data) {
    if(data.httpStatus == HttpStatus.ok) {
      members = data.members;
      notifyListeners();
    } else {
      rootNavPushReplace("/fatal", FETCHED_CHANNEL_BAD_REQUEST);
    }
  }

  void _onNewMessageReceived(SendMessageResponsePacketData data) {
    // if the received message is not in the currently loaded
    // channel, the user will get a notification instead
    if(data.channel != channel.sId) return;

    if(data.httpStatus != HttpStatus.ok) {
      showErrorSnackBar("Couldn't send message!", channelContext);
      return;
    }

    fetchedMessages.insert(0, data.message);
    notifyListeners();
  }


  void initialFetch() {
    // fetches first page of messages
    fetchNextPage();

    fetchMembers();
  }

  void fetchNextPage() {
    var conn = Provider.of<ServerConnection>(channelContext, listen: false);
    var request = PopulateMessagesRequestPacket(PopulateMessagesRequestPacketData(
      forChannel: channel.sId,
      page: messagePage + 1,
    ));
    conn.sendPacket(request);
  }

  void fetchMembers() {
    var conn = Provider.of<ServerConnection>(channelContext, listen: false);
    var request = FetchMembersRequestPacket(FetchMembersRequestPacketData(
      channel: channel.sId
    ));
    conn.sendPacket(request);
  }

  List<String> getMemberIds() {
    var list = <String>[];
    for(User u in members) list.add(u.sId);
    return list;
  }

  @override
  void dispose() {
    _fetchMessagesWait.dispose();
    _fetchMembersWait.dispose();
    _newMessageWait.dispose();
    super.dispose();
  }
}