import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///D:/dev/Programming/Dart/Flutter/zephy_client/lib/models/channel_model.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/packet/packet_handler.dart';
import 'file:///D:/dev/Programming/Dart/Flutter/zephy_client/lib/screens/inbox_screen/sidebar/single_channel_display.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class SidebarChannelDisplay extends StatefulWidget {

  final GlobalKey<NavigatorState> chatNav;

  SidebarChannelDisplay(this.chatNav);

  @override
  _SidebarChannelDisplayState createState() => _SidebarChannelDisplayState();
}

class _SidebarChannelDisplayState extends State<SidebarChannelDisplay> {

  ServerConnection _conn;
  ProfileData _profileData;


  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);
    _profileData = Provider.of<ProfileData>(context);

    Size size = MediaQuery.of(context).size;

    
    return FutureProvider<AccessibleChannelsInfoPacketData>(
      create: (_) async {
        return await _profileData.fetchAccessibleChannels(_conn);
      },
      child: Consumer<AccessibleChannelsInfoPacketData>(
        builder: (context, val, _) {
          if(val == null) return Center(child: Text("Loading..."));

          return Container(
            color: Colors.blue,
            height: size.height,
            width: 80,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 30),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: val.accessibleChannelsData.length,

              itemBuilder: (context, index) {
                BaseChannelData currData = val.accessibleChannelsData[index];
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Consumer<PacketHandler>(
                        builder: (_, __, ___) {
                          return SingleChannelDisplay(widget.chatNav, currData);
                        }
                    )
                );
              },
            ),
          );
        },
      ),
    );

  }
}
