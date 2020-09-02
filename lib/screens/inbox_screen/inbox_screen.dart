import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';

import 'chat_display.dart';

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
        appBar: AppBar(
            centerTitle: true,
            title: FutureProvider<AccessibleChannelsInfoPacketData>(
              create: (_) async {
                return await _profileData.fetchAccessibleChannels(_conn);
              },
              child: Consumer<AccessibleChannelsInfoPacketData>(
                builder: (context, val, _) {
                  if(val == null) return Center(child: Text("Loading..."));

                  return Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: val.accessibleChannelsData.length,

                      itemBuilder: (context, index) {
                        BaseChannelData currData = val.accessibleChannelsData[index];
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: CircleAvatar(
                                child: FlatButton(
                                  child: Text(currData.name.substring(0, 2)),
                                  onPressed: () {
                                    chatNavKey.currentState.pushReplacement(
                                      PageRouteBuilder(
                                          pageBuilder: (_, __, ___) {
                                            return ChatDisplay(forChannel: currData);
                                          }
                                      )
                                    );
                                  }
                                )
                            )
                        );
                      },
                    ),
                  );
                },
              ),
            )
        ),
        body: Navigator(
          key: chatNavKey,
          initialRoute: null,
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (_) => Container()
            );
          },
        )
    );
  }

}
