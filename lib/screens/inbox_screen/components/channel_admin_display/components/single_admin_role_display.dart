import 'package:flutter/material.dart';
import 'package:zephy_client/app/color_sets.dart';
import 'package:zephy_client/app/text_styles.dart';
import 'package:zephy_client/models/role_model.dart';

import '../channel_admin_display_logic.dart';

class SingleAdminRoleDisplay extends StatelessWidget {

  final Role role;
  final ChannelAdminDisplayLogic logic;
  SingleAdminRoleDisplay(this.role, this.logic);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(role.name),
        SizedBox(width: 10),
        FlatButton(
            child: Text(
                "remove",
                style: AppTextStyles.buttonLabelStyle
            ),
            color: ColorSets.primary,
            onPressed: () => logic.onDeleteRoleButton(role)
        ),
      ],
    );
  }
}
