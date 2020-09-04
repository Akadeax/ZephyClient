import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/screens/inbox_screen/chat_message_cache.dart';
import 'package:zephy_client/screens/inbox_screen/single_message_display.dart';
import 'package:zephy_client/services/server_connection.dart';

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
      if(isAtEnd) {
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

    if(msgCache.currentDisplayMessages.isEmpty) {
      return Container();
    }

    return Scaffold(
      body: Scrollbar(
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

  void loadNextPage() async {
    await msgCache.loadNextPage();
  }

  void updateDisplay() {
    setState(() {});
  }

  @override
  void dispose() {
    msgCache.dispose();
    super.dispose();
  }
}
