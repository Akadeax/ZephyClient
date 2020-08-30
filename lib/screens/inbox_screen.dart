import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/packet/channel/request_accessible_channels_info_packet.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';

class InboxScreen extends StatefulWidget {

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  ServerConnection conn;
  ProfileData profileData;
  @override
  Widget build(BuildContext context) {
    conn = Provider.of<ServerConnection>(context);
    profileData = Provider.of<ProfileData>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Row(
        children: [
          _sidebar(),
          _chat(),
        ],
      ),
    );
  }

  Widget _sidebar() {
    return Container(
      color: Colors.lightBlueAccent,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
          ),
          FlatButton(
            child: Text("press"),
            onPressed: () {
              RequestAccessibleChannelsInfoPacket packet = RequestAccessibleChannelsInfoPacket(
                  RequestAccessibleChannelsInfoPacketData(forUser: profileData.loggedInUser.sId)
              );
              conn.sendPacket(packet);
            },
          )
        ],
      ),
    );
  }

  Widget _chat() {
    return Text("CHAT");
  }
}
