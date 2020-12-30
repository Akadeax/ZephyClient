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
        color: ColorSets.primary,
      ),
    );
  }

  Widget sidebarChannelsDisplay(AccessibleChannelsInfoPacketData data) {
    return FractionallySizedBox(
      heightFactor: 1.0,
      child: Container(
        width: SidebarChannelsDisplayAppData.sidebarWidth,
        color: ColorSets.primary,
        child: sidebarChannelsListView(data),
      ),
    );
  }

  Widget sidebarChannelsListView(AccessibleChannelsInfoPacketData data) {
    return ListView.builder(
        padding: SidebarChannelsDisplayAppData.listViewPadding,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: data.accessibleChannelsData.length,
        itemBuilder: (ctx, i) => logic.channelsListViewItemBuilder(i, data)
    );
  }
}
