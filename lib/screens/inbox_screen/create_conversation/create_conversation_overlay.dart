import 'package:flutter/material.dart';
import 'package:zephy_client/components/listed_user_modal.dart';

class CreateConversationModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListedUserModal(
      title: "Create Conversation with...",
    );
  }
}
