import 'package:flutter/material.dart';
import 'package:zephy_client/components/listed_user_modal.dart';
import 'package:zephy_client/networking/packet/user/fetch_user_list_request_packet.dart';

class CreateConversationOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListedUserModal(
      title: "Create Conversation with...",
      onUsersReceived: (search, conn) {
        var packet = FetchUserListRequestPacket(FetchUserListRequestPacketData(
          search: search
        ));
        conn.sendPacket(packet);
      },
    );
  }
}
