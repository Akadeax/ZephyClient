import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/screens/inbox_screen/chat_message_cache.dart';
import 'package:zephy_client/services/server_connection.dart';

class ChatDisplay extends StatefulWidget {

  final BaseChannelData forChannel;

  ChatDisplay({this.forChannel});

  @override
  _ChatDisplayState createState() => _ChatDisplayState();
}

class _ChatDisplayState extends State<ChatDisplay> {
  ServerConnection _conn;
  ChatMessageCache msgCache;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);
    if(msgCache == null) {
      msgCache = ChatMessageCache(_conn, widget.forChannel);
    }

    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text("Chat for ${widget.forChannel.name}!"),
      ),
    );
  }
}
