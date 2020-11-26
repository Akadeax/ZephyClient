import 'package:flutter/material.dart';
import 'package:zephy_client/app/color_sets.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';

import 'sidebar_channels_display_logic.dart';

class SidebarChannelsDisplay extends StatefulWidget {
  @override
  SidebarChannelsDisplayState createState() => SidebarChannelsDisplayState();
}

class SidebarChannelsDisplayState extends State<SidebarChannelsDisplay> {
  SidebarChannelsDisplayLogic logic;
  SidebarChannelsDisplayState() {
    logic = SidebarChannelsDisplayLogic(this);
  }

  @override
  Widget build(BuildContext context) {
    return logic.streamBuilder(context);
  }

  Widget waitingDisplay() {
    return FractionallySizedBox(
      heightFactor: 1.0,
      child: Container(
        width: SidebarChannelsDisplayAppData.sidebarWidth,
        color: AppColorSets.colorPrimaryBlue,
      ),
    );
  }

  Widget sidebarChannelsDisplay(AccessibleChannelsInfoPacketData data) {
    return FractionallySizedBox(
      heightFactor: 1.0,
      child: Container(
        width: SidebarChannelsDisplayAppData.sidebarWidth,
        color: AppColorSets.colorPrimaryBlue,
        child: logic.channelsListView(data)
      ),
    );
  }
}
