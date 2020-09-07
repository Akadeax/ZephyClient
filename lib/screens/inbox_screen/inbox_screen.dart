import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/screens/inbox_screen/single_channel_display.dart';
import 'package:zephy_client/services/packet_handler.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';

class InboxScreen extends StatefulWidget {

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  ProfileData _profileData;
  ServerConnection _conn;

  GlobalKey<NavigatorState> chatNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    _profileData = Provider.of<ProfileData>(context);
    _conn = Provider.of<ServerConnection>(context);

    return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _sidebar(context),
            _chat(context),
          ],
        )
    );
  }

  Widget _sidebar(BuildContext context) {
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
                        return SingleChannelDisplay(chatNavKey, currData);
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

  Widget _chat(BuildContext context) {
    return Expanded(
      child: Navigator(
        key: chatNavKey,
        initialRoute: null,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (_) => Container()
          );
        },
      ),
    );
  }


  @override
  void dispose() {
    _conn.closeConnection();
    super.dispose();
  }
}