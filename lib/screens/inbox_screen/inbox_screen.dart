import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/screens/inbox_screen/chat_display.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';

class InboxScreen extends StatefulWidget {

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  ProfileData _profileData;
  ServerConnection _conn;

  GlobalKey<ChatDisplayState> chatDisplayKey = GlobalKey<ChatDisplayState>();

  @override
  Widget build(BuildContext context) {
    _profileData = Provider.of<ProfileData>(context);
    _conn = Provider.of<ServerConnection>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: FutureProvider<AccessibleChannelsInfoPacketData>(
        create: (_) async {
          var packet = AccessibleChannelsInfoPacket(AccessibleChannelsInfoPacketData(
              forUser: _profileData.loggedInUser.sId
          ));
          _conn.sendPacket(packet);

          var recvPacket = await _conn.waitForPacket<AccessibleChannelsInfoPacket>(
                  (buffer) => AccessibleChannelsInfoPacket.fromBuffer(buffer)
          );
          return recvPacket.readPacketData();
        },
        child: Row(
          children: [
            _sidebar(context),
            Expanded(child: ChatDisplay(key: chatDisplayKey)),
          ],
        ),
      ),
    );
  }

  Widget _sidebar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: 65,
      color: Colors.lightBlueAccent,
      child: Consumer<AccessibleChannelsInfoPacketData>(
        builder: (context, val, _) {
          if(val == null) return Center(child: Text("Loading..."));

          return ListView.builder(
            itemCount: val.accessibleChannelsData.length,
            itemBuilder: (context, index) {
              BaseChannelData currChannelData = val.accessibleChannelsData[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  child: FractionallySizedBox(
                    heightFactor: 1,
                    widthFactor: 1,
                    child: FlatButton(
                      child: Text(
                          currChannelData.name.substring(0, 2),
                          style: TextStyle(color: Colors.white)
                      ),
                      onPressed: () {
                        chatDisplayKey.currentState.displayChannel(currChannelData);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
