import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/old/screens/inbox_screen/chat/chat_display.dart';
import 'package:zephy_client/prov/chat_nav.dart';
import 'package:zephy_client/prov/current_display_channel.dart';
import 'package:zephy_client/utils/nav_util.dart';

class SingleChannelDisplayLogic {
  final BaseChannelData data;
  SingleChannelDisplayLogic(this.data);

  void pushChatDisplay(BuildContext context) {
    ChatNav chatNav = Provider.of<ChatNav>(context, listen: false);
    CurrentDisplayChannel currentDisplayChannel = Provider.of<CurrentDisplayChannel>(context, listen: false);

    pushOnNav(ChatDisplay(), chatNav.currentState);
    currentDisplayChannel.reset();
    currentDisplayChannel.baseChannelData = data;
  }

  void pushAdminDisplay(BuildContext context) {
    ChatNav chatNav = Provider.of<ChatNav>(context, listen: false);
    CurrentDisplayChannel currentDisplayChannel = Provider.of<CurrentDisplayChannel>(context, listen: false);

    // TODO: push admin page
    pushOnNav(Container(color: Colors.black), chatNav.currentState);
    currentDisplayChannel.reset();
    currentDisplayChannel.baseChannelData = data;
  }
}