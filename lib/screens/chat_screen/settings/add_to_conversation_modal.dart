import 'package:flutter/material.dart';
import 'package:zephy_client/components/listed_user_modal.dart';
import 'package:zephy_client/providers/current_channel.dart';

class AddToConversationModal extends StatelessWidget {
  final CurrentChannel channel;
  AddToConversationModal({@required this.channel});

  @override
  Widget build(BuildContext context) {

    return ListedUserModal(
      title: "Create Conversation with...",
      optionalExcludes: () => channel.getMemberIds(),
    );
  }
}
