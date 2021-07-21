import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/channel/modify_members_request_packet.dart';
import 'package:zephy_client/providers/current_channel.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/screens/chat_screen/settings/add_to_conversation_modal.dart';
import 'package:zephy_client/screens/chat_screen/settings/removable_member_card.dart';

class ChatSettingsModal extends StatefulWidget {
  final CurrentChannel channel;
  ChatSettingsModal({
    @required this.channel,
    Key key
  }) : super(key: key);

  @override
  _ChatSettingsModalController createState() => _ChatSettingsModalController();
}

class _ChatSettingsModalController extends State<ChatSettingsModal> {
  @override
  Widget build(BuildContext context) => _ChatSettingsModalView(this);

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.channel.channel.name;
    super.initState();
  }

  Widget itemBuilder(BuildContext context, int i) {
    return RemovableMemberCard(
      member: widget.channel.members[i],
      onRemovePressed: onRemovePressed,
    );
  }

  void onRemovePressed(ListedUser member) {
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);

    var packet = ModifyMembersRequestPacket(ModifyMembersRequestPacketData(
      action: MemberAction.REMOVE_MEMBER,
      user: member.sId,
      channel: widget.channel.channel.sId,
    ));

    conn.sendPacket(packet);
  }

  void onAddPressed(BuildContext context) {
    showDialog(context: context, builder: (_) {
      return AddToConversationModal(
        channel: widget.channel,
      );
    });
  }
}

class _ChatSettingsModalView extends StatefulWidgetView<ChatSettingsModal, _ChatSettingsModalController> {
  const _ChatSettingsModalView(_ChatSettingsModalController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: theme.colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),

      children: [
        Container(
            width: size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 70),
                        child: TextField(
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        )
                      ),
                      Positioned(
                        right: 10,
                        top: 5,
                        child: IconButton(
                          splashRadius: 20,
                          icon: Icon(Icons.person_add),
                          onPressed: () => controller.onAddPressed(context),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Consumer<CurrentChannel>(
                    builder: (_, __, ___) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        shrinkWrap: true,
                        itemCount: widget.channel.members.length,
                        itemBuilder: controller.itemBuilder,
                      );
                    }
                  ),
                ),
              ],
            )
        )
      ],
    );
  }

  Widget buildTopBar(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 20,
          child: Text(
            "test",
            style: theme.textTheme.subtitle1,
          ),
        ),
      ],
    );
  }
}