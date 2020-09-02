import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/packet/channel/request_accessible_channels_info_packet.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';

class InboxScreen extends StatefulWidget {

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  ProfileData _profileData;
  ServerConnection _conn;

  @override
  Widget build(BuildContext context) {
    _profileData = Provider.of<ProfileData>(context);
    _conn = Provider.of<ServerConnection>(context);

    print("BUILDING");
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: FutureProvider<AccessibleChannelsInfoPacketData>(
        create: (_) async {
          var packet = RequestAccessibleChannelsInfoPacket(RequestAccessibleChannelsInfoPacketData(
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
            _chat(),
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
          if(val == null) return Container();

          return ListView.builder(
            itemCount: val.accessibleChannelsData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  child: Text(val.accessibleChannelsData[index].name[0]),
                ),
              );
            },
          );
        },
      )
    );
  }

  Widget _chat() {
    return Text("CHAT");
  }
}
