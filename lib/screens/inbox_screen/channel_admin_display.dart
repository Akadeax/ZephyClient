import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/packet/channel/fetch_channel_roles_packet.dart';
import 'package:zephy_client/packet/channel/modify_channel_roles_packet.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class ChannelAdminDisplay extends StatelessWidget {

  final BaseChannelData channel;
  ChannelAdminDisplay(this.channel);



  @override
  Widget build(BuildContext context) {
    ServerConnection _conn = Provider.of<ServerConnection>(context);
    var packet = FetchChannelRolesPacket(FetchChannelRolesPacketData(
      forChannel: channel.sId,
    ));
    _conn.sendPacket(packet);

    return FutureProvider<FetchChannelRolesPacketData>(
      create: (context) async {
        var packet = await _conn.packetHandler.waitForPacket<FetchChannelRolesPacket>(
            FetchChannelRolesPacket.TYPE,
            (buffer) => FetchChannelRolesPacket.fromBuffer(buffer)
        );
        return packet.readPacketData();
      },
      child: Consumer<FetchChannelRolesPacketData>(
        builder: (context, data, _) {
          if(data == null) return Container(color: Colors.grey[800]);

          return ListView.builder(
            itemCount: data.roles.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Text("role: ${data.roles[index].name}"),
                  SizedBox(width: 20),
                  FlatButton(
                    child: Text("remove"),
                    color: Colors.blue,
                    onPressed: () {
                      var packet = ModifyChannelRolesPacket(ModifyChannelRolesPacketData(
                        action: ModifyChannelRolesAction.REMOVE,
                        channel: channel.sId,
                        role: data.roles[index].sId
                      ));

                      _conn.sendPacket(packet);
                    },
                  ),
                ],
              );
            },
          );
        }
      )
    );
  }
}
