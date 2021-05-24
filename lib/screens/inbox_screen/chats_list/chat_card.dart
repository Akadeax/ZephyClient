import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/util/color_util.dart';
import 'package:zephy_client/util/string_util.dart';
import 'package:zephy_client/util/time_util.dart';

class ChatCard extends StatelessWidget {
  final BaseChannelData channel;
  final void Function() onPressed;

  const ChatCard({
    Key key,
    @required this.channel,
    this.onPressed,
  }) : super(key: key);


  String getChannelTitle() {
    return shortenIfNeeded(channel.name, 30);
  }

  String getChannelSubText() {
    if(channel.lastMessage == null) return "Start to chat!";
    return shortenIfNeeded(channel.lastMessage.content, 40);
  }

  String getTimeAgoText() {
    if(channel.lastMessage == null) return "";
    return timestampToShortForm(channel.lastMessage.sentAt);
  }

  @override
  Widget build(BuildContext context) => _ChatCardView(this);
}



class _ChatCardView extends StatelessWidgetView<ChatCard> {
  const _ChatCardView(ChatCard controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Push chat page
      },
      child: Container(
        height: 70,
        child: buildStack(context),
      ),
    );
  }

  Widget buildStack(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 25,
          child: CircleAvatar(
            backgroundColor: rndChannelIconColor,
          ),
        ),
        Positioned(
          top: 15,
          left: 80,
          child: Text(
            controller.getChannelTitle(),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 80,
          child: Text(
            controller.getChannelSubText(),
            style: theme.textTheme.caption,
          ),
        ),
        Positioned(
          right: 15,
          top: 15,
          child: Text(
            controller.getTimeAgoText(),
            style: theme.textTheme.caption,
          )
        ),
      ],
    );
  }
}