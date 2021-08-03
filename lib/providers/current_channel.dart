import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/components/error_snack_bar.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/models/message.dart';
import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/channel/modify_channel_request_packet.dart';
import 'package:zephy_client/networking/packet/channel/modify_channel_response_packet.dart';
import 'package:zephy_client/networking/packet/channel/modify_members_request_packet.dart';
import 'package:zephy_client/networking/packet/channel/modify_members_response_packet.dart';
import 'package:zephy_client/networking/packet/message/populate_messages_request_packet.dart';
import 'package:zephy_client/networking/packet/message/populate_messages_response_packet.dart';
import 'package:zephy_client/networking/packet/message/send_message_response_packet.dart';
import 'package:zephy_client/networking/packet/packet.dart';
import 'package:zephy_client/networking/packet/packet_wait.dart';
import 'package:zephy_client/networking/packet/user/fetch_members_request_packet.dart';
import 'package:zephy_client/networking/packet/user/fetch_members_response_packet.dart';
import 'package:zephy_client/providers/profile_handler.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/util/bit_converter.dart';
import 'package:zephy_client/util/nav_util.dart';

class CurrentChannel extends ChangeNotifier {
  static const int PAGE_SIZE = 25;
  static const String FETCHED_CHANNEL_BAD_REQUEST = "Fetched Channel was bad request.";

  BaseChannelData channel;
  List<PopulatedMessage> fetchedMessages = [];
  List<ListedUser> members;
  int messagePage = -1;

  BuildContext channelContext;

  PacketWaitList packetList = PacketWaitList();

  CurrentChannel(this.channel, BuildContext context) {
    channelContext = context;
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);

    packetList.add(
        PopulateMessagesResponsePacket.TYPE,
            (buffer) => PopulateMessagesResponsePacket.fromBuffer(buffer),
            (p) => _onFetchedMessagesReceived(p.readPacketData())
    );
    packetList.add(
        FetchMembersResponsePacket.TYPE,
            (buffer) => FetchMembersResponsePacket.fromBuffer(buffer),
            (p) => _onFetchedMembersReceived(p.readPacketData())
    );
    packetList.add(
        SendMessageResponsePacket.TYPE,
            (buffer) => SendMessageResponsePacket.fromBuffer(buffer),
            (p) => _onNewMessageReceived(p.readPacketData())
    );
    packetList.add(
        ModifyMembersResponsePacket.TYPE,
            (buffer) => ModifyMembersResponsePacket.fromBuffer(buffer),
            (p) => _onModifyMembersReceived(p.readPacketData())
    );
    packetList.add(
        ModifyChannelResponsePacket.TYPE,
            (buffer) => ModifyChannelResponsePacket.fromBuffer(buffer),
            (p) => _onModifyChannelReceived(p.readPacketData())
    );

    packetList.start(context);
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

  void _onModifyMembersReceived(ModifyMembersResponsePacketData data) {
    if(data.httpStatus == HttpStatus.conflict) {
      showErrorSnackBar("That user has already been added!", channelContext);
    } else if(data.httpStatus == HttpStatus.notFound) {
      showErrorSnackBar("That user is not a member of that channel!", channelContext);
    }

    if(data.httpStatus != HttpStatus.ok) return;

    switch(data.action) {
      case MemberAction.ADD_MEMBER:
        members.add(data.user);
        break;

      case MemberAction.REMOVE_MEMBER:
        members.removeWhere((u) => u.sId == data.user.sId);
        ProfileHandler profile = Provider.of<ProfileHandler>(channelContext, listen: false);
        if(profile.user.sId == data.user.sId) {
          rootNavPushReplace("/inbox");
        }
        break;

    }

    notifyListeners();
  }

  void _onModifyChannelReceived(ModifyChannelResponsePacketData data) {
    if(data.httpStatus == HttpStatus.notFound) {
      showErrorSnackBar("that channel couldn't be found!", channelContext);
    } else if(data.httpStatus == HttpStatus.badRequest) {
      showErrorSnackBar("that modification is invalid!", channelContext);
    }

    if(data.httpStatus != HttpStatus.ok) return;

    switch(data.action) {
      case ChannelAction.MODIFY_NAME:
        channel.name = data.data;
        break;
    }

    notifyListeners();
  }

  /// fetches first page of messages and all members
  void initialFetch() {
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
    for(ListedUser u in members) list.add(u.sId);
    return list;
  }

  @override
  void dispose() {
    packetList.dispose();
    super.dispose();
  }
}