import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/circle_decoration_painter.dart';
import 'package:zephy_client/components/loading/errable_loading.dart';
import 'package:zephy_client/networking/packet/auth/confirm_session_request_packet.dart';
import 'package:zephy_client/networking/packet/auth/confirm_session_response_packet.dart';
import 'package:zephy_client/providers/profile_handler.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/providers/server_locator.dart';
import 'package:zephy_client/util/nav_util.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenController createState() => _ConnectionScreenController();
}

class _ConnectionScreenController extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) => _ConnectionScreenView(this);

  ServerLocator locator;
  Future currentLocateFuture;

  GlobalKey<ErrableLoadingController> loadingKey = GlobalKey();

  @override
  void initState() {
    locator = Provider.of<ServerLocator>(context, listen: false);
    currentLocateFuture = locator.locate();
    super.initState();
  }

  FutureBuilder locateBuilder({
    @required BuildContext context,
    @required ErrableLoading loading,
  }) {
    return FutureBuilder(
        future: currentLocateFuture,
        builder: (builderCtx, snapshot) {
          bool dataIsValid = !snapshot.hasError && snapshot.data != null;
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;

          // Server Location was successful
          if (dataIsValid && !isLoading) {
            onConnected(context);
            return Container();
          }

          bool shouldShowError = !dataIsValid && !isLoading;

          if(loadingKey.currentState != null)
            loadingKey.currentState.showError = shouldShowError;

          return loading;
        }
    );
  }

  void onConnected(BuildContext context) async {
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    await conn.connect(locator.lastBroadcastResult);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("accessToken");
    print("GETTING: $accessToken");

    var requestPacket = ConfirmSessionRequestPacket(ConfirmSessionRequestPacketData(
      accessToken: accessToken
    ));
    conn.sendPacket(requestPacket);

    var response = (await conn.packetHandler.waitForPacket(
        ConfirmSessionResponsePacket.TYPE,
        (buffer) => ConfirmSessionResponsePacket.fromBuffer(buffer)
    )).readPacketData();

    switch(response.httpStatus) {
      case HttpStatus.ok:
        Provider.of<ProfileHandler>(context, listen: false)
            .user = response.user;
        rootNavPushReplace("/inbox");
        break;

      default:
        rootNavPushReplace("/login");
        break;
    }
  }

  void retryButton() {
    setState(() {
      currentLocateFuture = locator.locate();
    });
  }
}


class _ConnectionScreenView extends StatefulWidgetView<ConnectionScreen, _ConnectionScreenController> {
  _ConnectionScreenView(_ConnectionScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(flex: 25, child: Container()),
            Expanded(
              flex: 35,
              child: controller.locateBuilder(
                context: context,
                loading: ErrableLoading(
                  key: controller.loadingKey,
                  onErrorButtonPress: controller.retryButton,

                  singleBallSize: 25,
                  loadingSize: 85,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: CustomPaint(
                size: Size.infinite,
                painter: CircleDecorationPainter(
                    theme: Theme.of(context)
                ),
              ),
            ),
          ]
        )
    );
  }
}
