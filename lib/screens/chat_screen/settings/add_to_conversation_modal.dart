import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/components/listed_user_modal.dart';
import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/channel/modify_members_request_packet.dart';
import 'package:zephy_client/providers/current_channel.dart';
import 'package:zephy_client/providers/server_connection.dart';

class AddToConversationModal extends StatelessWidget {
  final CurrentChannel channel;
  AddToConversationModal({@required this.channel});

  @override
  Widget build(BuildContext context) {

    return ListedUserModal(
      title: "Add to Conversation...",
      optionalExcludes: () => channel.getMemberIds(),
      onUserPressed: (ListedUser user) {
        ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);

        var packet = ModifyMembersRequestPacket(ModifyMembersRequestPacketData(
          action: MemberAction.ADD_MEMBER,
          user: user.sId,
          channel: channel.channel.sId,
        ));

        conn.sendPacket(packet);
      },
    );
  }
}
