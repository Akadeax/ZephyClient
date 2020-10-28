import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/networking/server_locator.dart';
import 'package:zephy_client/screens/login_screen/login_screen.dart';
import 'package:zephy_client/utils/nav_util.dart';

import 'connection_screen.dart';

class ConnectionScreenAppData {
  static const String connectionFailedText = "Couldn't connect to server. Please try again at a later time or contact an administrator.";
  static const String retryButtonText = "retry";
  static const double retrySeperatorHeight = 25;
}

class ConnectionScreenLogic {

  final ConnectionScreenState screen;

  ServerLocator locator;
  Future currentLocateFuture;


  ConnectionScreenLogic(this.screen) {
    locator = ServerLocator(sendPort: 6556, listenPort: 6557);
    currentLocateFuture = locator.locate();
  }

  FutureBuilder locateBuilder(BuildContext context) {
    return FutureBuilder(
      future: currentLocateFuture,
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          Provider.of<ServerConnection>(context).connect(snapshot.data);
          pushLoginScreen(context, snapshot.data);
          return Container();
        } else if(snapshot.connectionState == ConnectionState.waiting) {
          return screen.loadingWidget;
        } else {
          return screen.retryConnectionWidget;
        }
      },
    );
  }

  void pushLoginScreen(BuildContext context, data) {
    pushNextFrame(LoginScreen(data), context);
  }

  void onRetryPressed() {
    currentLocateFuture = locator.locate();
    screen.update();
  }
}