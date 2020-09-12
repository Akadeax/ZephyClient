import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/packet/identify_packet.dart';
import 'package:zephy_client/packet/message/message_send_packet.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class SendMessageDisplay extends StatefulWidget {
  final BaseChannelData channel;


  SendMessageDisplay(this.channel);

  @override
  _SendMessageDisplayState createState() => _SendMessageDisplayState();
}

class _SendMessageDisplayState extends State<SendMessageDisplay> {

  ServerConnection _conn;

  String currMessage = "";

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 50,
      color: Colors.blue,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: size.width / 2,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Message",
                ),
              ),
            ),
            FlatButton(
              child: Text(
                "send",
              ),
              color: Colors.greenAccent,
              onPressed: () async {
                if(_controller.text.isEmpty) return;

                MessageSendPacket sendPacket = MessageSendPacket(MessageSendPacketData(
                  message: _controller.text,
                  channel: widget.channel.sId,
                ));

                _conn.sendPacket(sendPacket);


                var id = await _conn.packetHandler.waitForPacket<IdentifyPacket>(
                    IdentifyPacket.TYPE,
                    (buffer) => IdentifyPacket.fromBuffer(buffer)
                );

                _controller.text = id.readPacketData().src;
              },
            ),
          ],
        )
      )
    );
  }
}
