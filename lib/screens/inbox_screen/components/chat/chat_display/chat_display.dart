import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/prov/current_display_channel.dart';
import 'file:///D:/dev/Programming/Dart/Flutter/zephy_client/lib/screens/inbox_screen/components/chat/message_send_display/messsage_send_display.dart';

import 'chat_display_logic.dart';
import '../chat_info_display.dart';

class ChatDisplay extends StatefulWidget {
  @override
  _ChatDisplayState createState() => _ChatDisplayState();
}

class _ChatDisplayState extends State<ChatDisplay> {
  ChatDisplayLogic logic = ChatDisplayLogic();

  @override
  Widget build(BuildContext context) {
    logic.init(context);

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: ChatInfoDisplay(),
        ),
        Expanded(
          flex: 15,
          child: messageListView(context)
        ),
        Expanded(
          flex: 2,
          child: MessageSendDisplay()
        ),
      ],
    );
  }

  Widget messageListView(BuildContext context) {
    CurrentDisplayChannel channel = Provider.of<CurrentDisplayChannel>(context);

    return Scrollbar(
      child: ListView.builder(
        controller: logic.scrollController,
        itemCount: channel.messages.length,
        scrollDirection: Axis.vertical,
        reverse: true,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: logic.messageItemBuilder(context, i),
          );
        },
      ),
    );

  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }
}
