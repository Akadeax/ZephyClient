import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/field_avatar.dart';
import 'package:zephy_client/models/message.dart';
import 'package:zephy_client/providers/profile_handler.dart';
import 'package:zephy_client/util/time_util.dart';

class SingleMessageDisplay extends StatelessWidget {
  final PopulatedMessage message;

  SingleMessageDisplay({
    @required this.message,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _SingleMessageDisplayView(this);

  /// Whether the currently logged in user is the author
  /// of this message
  bool isClient(BuildContext context) {
    var profile = Provider.of<ProfileHandler>(context, listen: false);
    return profile.user.sId == message.author.sId;
  }

  String getMessageCaption(BuildContext context) {
    if(isClient(context)) {
      return sentAgo;
    }
    return "${message.author.fullName}, $sentAgo";
  }

  String get sentAgo {
    return timestampToShortForm(message.sentAt);
  }
}

class _SingleMessageDisplayView extends StatelessWidgetView<SingleMessageDisplay> {
  const _SingleMessageDisplayView(SingleMessageDisplay controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    var children = [
      FieldAvatar(
        baseText: controller.message.author.fullName,
        sId: controller.message.author.sId,
      ),
      SizedBox(width: 10),
      textBubble(context),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: controller.isClient(context)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
        children: controller.isClient(context)
          ? children.reversed.toList()
          : children,
      ),
    );
  }

  Widget textBubble(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        minWidth: 30,
        maxWidth: size.width - 100,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: controller.isClient(context)
          ? theme.colorScheme.secondary
          : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: bubbleContent(context),
    );
  }

  Widget bubbleContent(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.getMessageCaption(context),
          style: theme.textTheme.caption.copyWith(
            color: controller.isClient(context)
              ? Colors.white60
              : theme.colorScheme.onSurface,
          ),
        ),
        Container(
          child: SelectableText(
            controller.message.content,
            style: theme.textTheme.bodyText2.copyWith(
              color: controller.isClient(context)
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.onBackground,
            )
          ),
        ),
      ],
    );
  }
}