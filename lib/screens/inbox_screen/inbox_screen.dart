import 'package:flutter/material.dart';

import 'components/sidebar/sidebar_channels_display/sidebar_channels_display.dart';
import 'inbox_screen_logic.dart';

class InboxScreen extends StatelessWidget {
  final InboxScreenLogic logic = InboxScreenLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: logic.providers(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SidebarChannelsDisplay(),
            Expanded(
              child: logic.chatDisplayNav()
            ),
          ],
        ),
      )
    );
  }
}
