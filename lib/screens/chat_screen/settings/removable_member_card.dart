import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/field_avatar.dart';
import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/util/string_util.dart';

class RemovableMemberCard extends StatelessWidget {
  final User member;
  final Function(User member) onRemovePressed;
  RemovableMemberCard({
    @required this.member,
    @required this.onRemovePressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _RemoveableMemberCardView(this);

  String getName(int len) {
    return shortenIfNeeded(member.fullName, len);
  }

  String getStatus(int len) {
    return shortenIfNeeded(member.status, len);
  }
}

class _RemoveableMemberCardView extends StatelessWidgetView<RemovableMemberCard> {
  const _RemoveableMemberCardView(RemovableMemberCard controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 50,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: FieldAvatar(
                sId: controller.member.sId,
                baseText: controller.member.fullName,
              ),
            ),
            Positioned(
              top: 10,
              left: 50,
              child: Text(
                controller.getName(20),
                style: theme.textTheme.bodyText2,
              )
            ),
            Positioned(
              top: 25,
              left: 50,
              child: Text(
                controller.getStatus(22),
                style: theme.textTheme.caption,
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                splashRadius: 25,
                icon: Icon(Icons.remove),
                onPressed: () => controller.onRemovePressed(controller.member),
              )
            )
          ],
        ),
      ),
    );
  }
}