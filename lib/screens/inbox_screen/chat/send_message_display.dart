
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/packet/message/message_send_packet.dart';
import 'package:zephy_client/screens/inbox_screen/inbox_screen.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class SendMessageDisplay extends StatefulWidget {
  @override
  _SendMessageDisplayState createState() => _SendMessageDisplayState();
}

class _SendMessageDisplayState extends State<SendMessageDisplay> {

  ServerConnection _conn;

  String currMessage = "";

  TextEditingController _controller = TextEditingController();
  FocusNode _controllerFocus = FocusNode();
  DisplayChannel displayChannel;
  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);
    Size size = MediaQuery.of(context).size;
    displayChannel = Provider.of<DisplayChannel>(context);

    return Container(
        height: 50,
        color: Colors.blue,
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.6,
                  child: TextField(
                    focusNode: _controllerFocus,
                    controller: _controller,
                    autofocus: true,
                    textInputAction: TextInputAction.send,

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2000),
                    ],

                    onSubmitted: (value) {
                      _sendInputMessage();
                    },


                    decoration: InputDecoration(
                      hintText: "message....",
                    ),
                  ),
                ),
                _sendButton(),
              ],
            )
        )
    );
  }

  FlatButton _sendButton() {
    return FlatButton(
      child: Text(
        "send",
      ),
      color: Colors.greenAccent,
      onPressed: _sendInputMessage,
    );
  }

  void _sendInputMessage() {
    if(_controller.text.isEmpty) return;

    MessageSendPacket packet = MessageSendPacket(MessageSendPacketData(
      message: _controller.text,
      channel: displayChannel.baseChannelData.sId,
    ));

    _controller.clear();
    _controllerFocus.requestFocus();
    
    _conn.sendPacket(packet);
  }
}
