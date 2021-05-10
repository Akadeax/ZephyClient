import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/search_bar.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/services/networking/packet/channel/fetch_channels_request_packet.dart';
import 'package:zephy_client/services/networking/packet/channel/fetch_channels_response_packet.dart';
import 'package:zephy_client/services/networking/packet/packet_wait.dart';

import 'chat_card.dart';

class InboxScreen extends StatefulWidget {
  final Duration animDuration = const Duration(milliseconds: 300);

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

  @override
  void initState() {
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    channelFetchWait.startWait(
        conn,
        (packet) => onChannelsReceived(packet.readPacketData())
    );

    requestChannels(context, delay: const Duration(milliseconds: 300));
    initAnimationState();

    super.initState();
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

  /// updates displayChannels with newest data received
  void onChannelsReceived(FetchChannelsResponsePacketData data) async {
    if(data.httpStatus == HttpStatus.ok) {
      setState(() {
        displayChannels = data.channels;
      });

      listAnimController.reset();
      listAnimController.forward();
    }
  }

  void onChannelSearchChanged(BuildContext context, String search) {
    requestChannels(context, search: search);
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
  void onAddPressed() {
    // TODO: Add add page, hehe
  }

  void onSettingsPressed() {
    // TODO: Add settings screen
  }
  //endregion
}

class _InboxScreenView extends StatefulWidgetView <InboxScreen, _InboxScreenController> {
  const _InboxScreenView(_InboxScreenController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        onPressed: controller.onAddPressed,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 60),
            SizedBox(
              height: 90,
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

    return Container(
      color: theme.cardColor,
      padding: EdgeInsets.only(top: 20),
      child: FadeTransition(
        opacity: controller.animation,
        child: ListView.builder(
          itemCount: controller.displayChannels.length,
          itemBuilder: controller.channelsItemBuilder,
        ),
      ),
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
            SizedBox(
              child: SearchBar(
                hintText: "Find a conversation",
                onChanged: (s) => controller.onChannelSearchChanged(context, s),
              ),
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
