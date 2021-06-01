import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/providers/current_channel.dart';
import 'package:zephy_client/util/nav_util.dart';
import 'package:zephy_client/util/string_util.dart';

import 'message_list_display.dart';

class ChatScreen extends StatefulWidget {
  final BaseChannelData channel;

  ChatScreen(this.channel, {Key key}) : super(key: key);

  @override
  _ChatScreenController createState() => _ChatScreenController();
}

class _ChatScreenController extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) => _ChatScreenView(this);

  CurrentChannel _currentChannel;
  TextEditingController messageFieldController = TextEditingController();

  @override
  void initState() {
    _currentChannel = CurrentChannel(widget.channel, context);
    super.initState();
  }

  Widget channelProvider(BuildContext context, {@required Widget child}) {
    return ChangeNotifierProvider<CurrentChannel>.value(
      value: _currentChannel,
      child: child,
    );
  }

  void onBackPressed() {
    rootNavPushReplace("/inbox");
  }

  void onSettingsPressed() {
    // TODO: add settings
  }

  void onMessageSend(BuildContext context) {
    // TODO: message send packet
  }

  String get channelName {
    return shortenIfNeeded(_currentChannel.channel.name, 20);
  }

  @override
  void dispose() {
    _currentChannel.dispose();
    super.dispose();
  }
}

class _ChatScreenView extends StatefulWidgetView<ChatScreen, _ChatScreenController> {
  const _ChatScreenView(_ChatScreenController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return controller.channelProvider(
        context,
        child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: topBar(context),
                ),
                Expanded(
                  flex: 50,
                  child: Container(
                    color: theme.cardColor,
                    child: MessageListDisplay()
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: messageSendField(context),
                )
              ],
            )
        )
    );
  }

  Widget topBar(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned(
            left: 0,
            bottom: 10,
            child: IconButton(
                splashRadius: 20,
                onPressed: controller.onBackPressed,
              icon: Icon(Icons.arrow_back)
            ),
          ),
          Positioned(
            left: 60,
            bottom: 18,
            child: Text(
              controller.channelName,
              style: theme.textTheme.headline6,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 10,
            child:IconButton(
                splashRadius: 20,
                onPressed: controller.onSettingsPressed,
                icon: Icon(Icons.settings)
            ),
          )
        ],
      ),
    );
  }

  Widget messageSendField(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 30),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageFieldController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            width: 100,
            child: Material(
              color: theme.colorScheme.secondary,
              child: InkWell(
                child: Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
                onTap: () => controller.onMessageSend(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
