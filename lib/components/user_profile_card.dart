import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/field_avatar.dart';
import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/util/string_util.dart';

class UserProfileCard extends StatelessWidget {
  final ListedUser user;
  final void Function() onPressed;

  UserProfileCard({
    Key key,
    this.user,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _ProfileCardView(this);

  String getName() {
    return shortenIfNeeded(user.fullName, 20);
  }
}

class _ProfileCardView extends StatelessWidgetView<UserProfileCard> {
  const _ProfileCardView(UserProfileCard controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          buildAvatar(context),
          Positioned(
            bottom: 10,
            child: Text(
              controller.getName(),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAvatar(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Color statusColor = controller.user.onlineStatus == ListedUser.online ?
    Colors.greenAccent :
    Colors.grey;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [

        FieldAvatar(
          sId: controller.user?.sId,
          baseText: controller.user?.fullName,
          size: 25,
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: buildCircle(
                size: 15,
                color: theme.colorScheme.background,
                child: buildCircle(
                    size: 11,
                    color: statusColor
                )
            )
        ),
      ],
    );
  }

  Widget buildCircle({double size, Color color, Widget child}) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: child,
      ),
    );
  }
}