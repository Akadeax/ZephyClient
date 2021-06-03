import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/search_bar.dart';
import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/networking/packet/channel/create_channel_request_packet.dart';
import 'package:zephy_client/networking/packet/packet_wait.dart';
import 'package:zephy_client/networking/packet/user/fetch_user_list_request_packet.dart';
import 'package:zephy_client/networking/packet/user/fetch_user_list_response_packet.dart';
import 'package:zephy_client/providers/profile_handler.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/util/nav_util.dart';

import 'user_profile_card.dart';

class ListedUserModal extends StatefulWidget {
  final Duration animDuration = const Duration(milliseconds: 300);

  final String title;
  final List<String> Function() optionalExcludes;
  ListedUserModal({
    Key key,
    @required this.title,
    this.optionalExcludes,
  }) : super(key: key);

  @override
  _ListedUserModalController createState() => _ListedUserModalController();
}

class _ListedUserModalController extends State<ListedUserModal> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => _ListedUserModalView(this);

  int currentPage = 0;
  List<ListedUser> displayUsers = [];

  ScrollController scrollController = ScrollController();

  var userFetchWait = PacketWait<FetchUserListResponsePacket>(
      FetchUserListResponsePacket.TYPE,
      (buffer) => FetchUserListResponsePacket.fromBuffer(buffer)
  );

  @override
  void initState() {
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    userFetchWait.startWait(
        conn,
        (packet) => onUsersReceived(packet.readPacketData())
    );

    requestUsers(context, delay: const Duration(milliseconds: 300));
    initAnimationState();

    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  bool get listEndReached =>
      scrollController.offset >= scrollController.position.maxScrollExtent
          && !scrollController.position.outOfRange;

  void _scrollListener() {
    if(listEndReached) {
      requestUsers(context);
    }
  }

  //region animation
  AnimationController listAnimController;
  Animation<double> animation;

  void initAnimationState() {
    listAnimController = AnimationController(
      vsync: this,
      duration: widget.animDuration,
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(listAnimController);
  }
  //endregion

  /// update local display based on received packets
  void onUsersReceived(FetchUserListResponsePacketData data) {
    switch(data.httpStatus) {
      case HttpStatus.ok:
        print("Received page ${data.page}.");
        // if brand new search, reset usersPage and
        // give displayUsers new values
        if(data.page == 1) {
          displayUsers = data.users;

          // replay animation on new search only
          listAnimController.reset();
          listAnimController.forward();
        } else {
          // if next page on existing search, just
          // add to current display
          displayUsers.addAll(data.users);
        }
        currentPage = data.page;
        setState(() {});


        break;
      case HttpStatus.unauthorized:
        rootNavPushReplace("/fatal");
        break;
    }
  }

  void onUserSearchChanged(BuildContext context, String search) {
    // reset page back to first page after each new search
    currentPage = 0;
    scrollController.jumpTo(0);
    requestUsers(context, search: search);
  }


  /// requests channels from server through FetchUserListRequestPacket
  void requestUsers(BuildContext context, {String search = "", Duration delay}) async {
    if(delay != null) await Future.delayed(delay);

    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    var packet = FetchUserListRequestPacket(FetchUserListRequestPacketData(
      search: search,
      page: currentPage + 1,
      optionalExcludeIds: widget.optionalExcludes?.call(),
    ));
    print("Requesting page ${currentPage + 1}.");
    conn.sendPacket(packet);
  }


  Widget channelsItemBuilder(BuildContext context, int index) {
    return UserProfileCard(
      user: displayUsers[index],
      onPressed: () => onUserPressed(displayUsers[index]),
    );
  }

  void onUserPressed(ListedUser user) {
    ProfileHandler profile = Provider.of<ProfileHandler>(context, listen: false);
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    String name = "${profile.user.fullName}, ${user.fullName}";
    var packet = CreateChannelRequestPacket(CreateChannelRequestPacketData(
      name: name,
      withMembers: [profile.user.sId, user.sId],
    ));
    conn.sendPacket(packet);
  }

  @override
  void dispose() {
    listAnimController.dispose();
    userFetchWait.dispose();
    super.dispose();
  }
}

class _ListedUserModalView extends StatefulWidgetView<ListedUserModal, _ListedUserModalController> {
  const _ListedUserModalView(_ListedUserModalController controller) : super(controller);

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
          height: size.height * 0.7,
          width: size.width * 0.7,
          child: Column(
            children: [
              SizedBox(
                  height: 110,
                  child: buildTopBar(context)
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: FadeTransition(
                    opacity: controller.animation,
                    child: GridView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.displayUsers.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: controller.channelsItemBuilder,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildTopBar(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 20,
          child: Text(
            widget.title,
            style: theme.textTheme.subtitle1,
          ),
        ),
        Positioned(
          top: 50,
          child: SearchBar(
            width: size.width * 0.6,
            onChanged: (search) => controller.onUserSearchChanged(context, search),
            hintText: "Find someone",
          ),
        ),
      ],
    );
  }

}