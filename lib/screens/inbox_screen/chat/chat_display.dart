import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/screens/inbox_screen/chat/send_message_display.dart';
import 'package:zephy_client/screens/inbox_screen/single_message_display.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

import 'chat_message_cache.dart';

class ChatDisplay extends StatefulWidget {

  final BaseChannelData forChannel;

  ChatDisplay({this.forChannel});

  @override
  ChatDisplayState createState() => ChatDisplayState();
}


class ChatDisplayState extends State<ChatDisplay> {
  ServerConnection _conn;
  ChatMessageCache msgCache;

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(() async {
      bool isLoadingMessages = _conn.packetHandler.isPacketWaitOpen(PopulateMessagesPacket.TYPE);
      if(isAtEnd && !isLoadingMessages) {
        loadNextPage();
      }
    });
    super.initState();
  }

  bool get isAtEnd => _controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange;

  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);

    if(msgCache == null) {
      msgCache = ChatMessageCache(this, _conn, widget.forChannel);
      loadNextPage();
    }

    return Scaffold(
      body: Column(
          children: [
            _channelNameDisplay(context),
            _messageListView(),
            SendMessageDisplay(),
          ]
      ),
    );
  }

  Widget _channelNameDisplay(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        height: size.height / 10,
        color: Colors.blue,
        child: Center(
          child: Text(widget.forChannel.name),
        )
    );
  }

  Widget _messageListView() {
    if(msgCache.currentDisplayMessages.isEmpty) {
      return Expanded(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              color: Colors.grey,
            ),
          ),
        ),
      );

    } else {
      return Expanded(
        child: Scrollbar(
          child: ListView.builder(
            controller: _controller,
            reverse: true,
            itemCount: msgCache.currentDisplayMessages.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SingleMessageDisplay(
                    msgCache.currentDisplayMessages[index]
                ),
              );
            },
          ),
        ),
      );

    }
  }

  void loadNextPage() async {
    await msgCache.loadNextPage();
  }

  void updateDisplay() {
    if(this.mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    msgCache.dispose();
    super.dispose();
  }
}
