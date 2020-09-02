import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/services/server_connection.dart';

class ChatDisplay extends StatefulWidget {

  ChatDisplay({Key key}) : super(key: key);

  @override
  ChatDisplayState createState() => ChatDisplayState();
}

class ChatDisplayState extends State<ChatDisplay> {

  ServerConnection _conn;

  BaseChannelData _channelData;
  List<PopulatedMessage> _messages = new List<PopulatedMessage>();
  int _currentPage = 0;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() async {
    if (isAtEnd()) {
      List<PopulatedMessage> newMessages = await fetchMessages(++_currentPage);
      setState(() {
        _messages.addAll(newMessages);
      });
    }
  }
  bool isAtEnd() {
    return _controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange;
  }

  void displayChannel(BaseChannelData channelData) async {
    _resetChatDisplay();
    _channelData = channelData;
    List<PopulatedMessage> initialMessages = await fetchMessages(_currentPage);
    setState(() {
      _messages = initialMessages;
    });
  }

  void _resetChatDisplay() {
    _currentPage = 0;
    if(_controller.hasClients) {
      _controller.jumpTo(0);
    }
  }

  Future<List<PopulatedMessage>> fetchMessages(int page) async {
    PopulateMessagesPacket packet = PopulateMessagesPacket(PopulateMessagesPacketData(
      forChannel: _channelData.sId,
      page: page,
    ));
    _conn.sendPacket(packet);

    PopulateMessagesPacket recvPacket = await _conn.waitForPacket<PopulateMessagesPacket>((buffer) => PopulateMessagesPacket.fromBuffer(buffer));
    PopulateMessagesPacketData data = recvPacket.readPacketData();

    return data.populatedMessages;
  }


  @override
  Widget build(BuildContext context) {
    this._conn = Provider.of<ServerConnection>(context);
    if(_messages.isEmpty) {
      return Text(
        "No messages!",
        style: TextStyle(color: Colors.black, fontSize: 25),
      );
    }

    return ListView.builder(
      controller: _controller,
      reverse: true,
      itemCount: _messages.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return singleMessageDisplay(_messages[index]);
      },
    );
  }


  Widget singleMessageDisplay(PopulatedMessage message) {
    return Container(
      color: Colors.black,
      child: Text(
        "${message.author.name}: ${message.content}",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
