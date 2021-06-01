import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/error_snack_bar.dart';
import 'package:zephy_client/components/list_gradient.dart';
import 'package:zephy_client/components/search_bar.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/networking/packet/channel/create_channel_response_packet.dart';
import 'package:zephy_client/networking/packet/channel/fetch_channels_request_packet.dart';
import 'package:zephy_client/networking/packet/channel/fetch_channels_response_packet.dart';
import 'package:zephy_client/networking/packet/packet_wait.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/screens/inbox_screen/create_conversation/create_conversation_overlay.dart';
import 'package:zephy_client/util/nav_util.dart';

import 'chat_card.dart';

class InboxScreen extends StatefulWidget {
  final Duration animDuration = const Duration(milliseconds: 300);
  static const String UNAUTHORIZED_TO_FETCH_CHANNELS = "Unauthorized to fetch channels";
  static const String CREATE_CHANNEL_UNAUTHORIZED = "Unauthorized to create a new channel.";

  InboxScreen({Key key}) : super(key: key);

  @override
  _InboxScreenController createState() => _InboxScreenController();
}

class _InboxScreenController extends State<InboxScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => _InboxScreenView(this);


  List<BaseChannelData> displayChannels = [];

  var channelFetchWait = PacketWait<FetchChannelsResponsePacket>(
      FetchChannelsResponsePacket.TYPE,
      (buffer) => FetchChannelsResponsePacket.fromBuffer(buffer)
  );
  var newChannelWait = PacketWait<CreateChannelResponsePacket>(
      CreateChannelResponsePacket.TYPE,
      (buffer) => CreateChannelResponsePacket.fromBuffer(buffer)
  );

  ScaffoldMessengerState messenger;

  @override
  void initState() {
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);

    channelFetchWait.startWait(
        conn,
        (packet) => onChannelsReceived(packet.readPacketData())
    );
    newChannelWait.startWait(
        conn,
        (packet) => onNewChannelReceived(packet.readPacketData())
    );



    requestChannels(context, delay: const Duration(milliseconds: 300));
    initAnimationState();

    super.initState();
  }

  @override
  didChangeDependencies() {
    messenger = ScaffoldMessenger.of(context);
    super.didChangeDependencies();
  }

  //region animation
  AnimationController listAnimController;
  Animation<double> animation;

  void initAnimationState() {
    listAnimController = AnimationController(
      vsync: this,
      duration: widget.animDuration,
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(listAnimController);
  }
  //endregion

  /// update local display based on received packets
  void onChannelsReceived(FetchChannelsResponsePacketData data) {

    switch(data.httpStatus) {
      case HttpStatus.ok:
        displayChannels = data.channels;
        reloadListWithAnim();
        break;
      case HttpStatus.unauthorized:
        rootNavPushReplace("/fatal", InboxScreen.UNAUTHORIZED_TO_FETCH_CHANNELS);
        break;
    }
  }

  void onNewChannelReceived(CreateChannelResponsePacketData data) {
    Navigator.of(context).pop();

    switch(data.httpStatus) {
      case HttpStatus.ok:
        displayChannels.add(data.newChannel.toBaseChannelData());
        reloadListWithAnim();
        break;
      case HttpStatus.unauthorized:
        rootNavPushReplace("/fatal", InboxScreen.CREATE_CHANNEL_UNAUTHORIZED);
        break;
      case HttpStatus.conflict:
        showErrorSnackBar("That channel already exists!", context);
        break;
      case HttpStatus.badRequest:
        showErrorSnackBar("That request was invalid!", context);
    }
  }

  void onChannelSearchChanged(BuildContext context, String search) {
    requestChannels(context, search: search);
  }

  void reloadListWithAnim() {
    listAnimController.reset();
    listAnimController.forward();
    setState(() {});
  }


  /// requests channels from server through FetchChannelsRequestPacket
  void requestChannels(BuildContext context, {String search = "", Duration delay}) async {
    if(delay != null) await Future.delayed(delay);

    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    var packet = FetchChannelsRequestPacket(FetchChannelsRequestPacketData(
      search: search,
    ));
    conn.sendPacket(packet);
  }


  Widget channelsItemBuilder(BuildContext context, int index) {
    return ChatCard(
      channel: displayChannels[index],
    );
  }

  //region redirects
  void onAddPressed(BuildContext context) {
    showDialog(context: context, builder: (_) {
      return CreateConversationOverlay();
    });
  }

  void onSettingsPressed() {
    // TODO: Add settings screen
  }
  //endregion

  @override
  void dispose() {
    listAnimController.dispose();
    channelFetchWait.dispose();
    newChannelWait.dispose();
    super.dispose();
  }
}

class _InboxScreenView extends StatefulWidgetView <InboxScreen, _InboxScreenController> {
  const _InboxScreenView(_InboxScreenController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30),
        backgroundColor: theme.colorScheme.primary,
        onPressed: () => controller.onAddPressed(context),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            SizedBox(
              height: 80,
              child: buildTopBar(context),
            ),

            SizedBox(height: 25),

            Expanded(
              child: buildList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          color: theme.cardColor,
          child: FadeTransition(
            opacity: controller.animation,
            child: ListView.builder(
              itemCount: controller.displayChannels.length,
              itemBuilder: controller.channelsItemBuilder,
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: ListGradient(top: true),
        ),
        Positioned(
          bottom: 0,
          child: ListGradient(top: false),
        )
      ],
    );
  }


  buildTopBar(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              "Chats",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SearchBar(
            hintText: "Find a conversation",
            onChanged: (s) => controller.onChannelSearchChanged(context, s),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              splashRadius: 15,
              iconSize: 25,
              icon: Icon(
                Icons.settings,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: controller.onSettingsPressed,
            ),
          ),
        ],
      ),
    );

  }
}
