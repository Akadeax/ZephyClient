import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/components/listed_user_modal.dart';
import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/channel/create_channel_request_packet.dart';
import 'package:zephy_client/providers/profile_handler.dart';
import 'package:zephy_client/providers/server_connection.dart';

class CreateConversationModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListedUserModal(
      title: "Create Conversation with...",
      onUserPressed: (ListedUser user) {
        ProfileHandler profile = Provider.of<ProfileHandler>(context, listen: false);
        ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);

        String name = "${profile.user.fullName}, ${user.fullName}";

        var packet = CreateChannelRequestPacket(CreateChannelRequestPacketData(
          name: name,
          withMembers: [profile.user.sId, user.sId],
        ));

        conn.sendPacket(packet);
      },
    );
  }
}
