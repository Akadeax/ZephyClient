import 'package:flutter/material.dart';
import 'package:zephy_client/screens/inbox_screen/components/channel_admin_display/components/add_role_display.dart';
import 'package:zephy_client/screens/inbox_screen/components/channel_admin_display/components/name_change_display.dart';

import 'channel_admin_display_logic.dart';

class ChannelAdminDisplay extends StatefulWidget {
  @override
  ChannelAdminDisplayState createState() => ChannelAdminDisplayState();
}

class ChannelAdminDisplayState extends State<ChannelAdminDisplay> {
  ChannelAdminDisplayLogic logic;
  ChannelAdminDisplayState() {
    logic = ChannelAdminDisplayLogic(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: NameChangeDisplay(logic)
        ),
        Expanded(
          flex: 9,
          child: logic.rolesDisplay(context)
        ),
        Expanded(
          flex: 1,
          child: AddRoleDisplay(logic)
        ),
      ],
    );
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }
}

