import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/field_avatar.dart';
import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/util/nav_util.dart';
import 'package:zephy_client/util/string_util.dart';
import 'package:zephy_client/util/time_util.dart';

class ChatCard extends StatelessWidget {
  final BaseChannelData channel;

  const ChatCard({
    Key key,
    @required this.channel,
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

  void onPressed() {
    rootNavPush("/chat", channel);
  }

  @override
  Widget build(BuildContext context) => _ChatCardView(this);
}



class _ChatCardView extends StatelessWidgetView<ChatCard> {
  const _ChatCardView(ChatCard controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.onPressed,
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
          child: FieldAvatar(
            sId: controller.channel?.sId,
            baseText: controller.channel?.name,
          )
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