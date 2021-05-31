import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/providers/current_channel.dart';

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

  CurrentChannel currentChannel;

  @override
  void initState() {
    currentChannel = CurrentChannel(widget.channel, context);
    super.initState();
  }

  Widget channelProvider(BuildContext context, {@required Widget child}) {
    return ChangeNotifierProvider<CurrentChannel>.value(
      value: currentChannel,
      child: child,
    );
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
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: theme.cardColor,
                    child: MessageListDisplay()
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                )
              ],
            )
        )
    );
  }
}
