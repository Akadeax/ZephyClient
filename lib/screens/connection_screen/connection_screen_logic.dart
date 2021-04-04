import 'package:flutter/material.dart';
import 'package:zephy_client/networking/server_locator.dart';
import 'package:zephy_client/utils/nav_util.dart';
import 'package:zephy_client/widgets/loading/loading.dart';

import 'connection_screen.dart';

class ConnectionScreenLogic {

  final ConnectionScreenState screen;
  ServerLocator locator;
  Future currentLocateFuture;

  ConnectionScreenLogic(this.screen) {
    locator = ServerLocator(sendPort: 6556, listenPort: 6557);
    currentLocateFuture = locator.locate();
  }


  FutureBuilder locateWidget(BuildContext context) {
    /*return FutureComponent(
      future: Future.delayed(Duration(seconds: 2)),
      loading: screen.loading(),
      error: (err) {
        return Container();
      },
      resolved: (data) {
        pushLoginScreen(context, data);
        return Container();
      },
    );*/

    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)),
      builder: (ctx, snapshot) {
        Loading loading = screen.loading();

        if(snapshot.connectionState == ConnectionState.done && snapshot.data != null)
          return Container();
        else if(snapshot.connectionState == ConnectionState.waiting) {
          loading.state.currentColors = loadingColors;
        }
        else {
          loading.state.currentColors = errorColors;
        }
        print("RET");
        return loading;
      }
    );
  }


  void onRetryPressed() {
    currentLocateFuture = locator.locate();
    screen.rebuild();
  }

  void pushLoginScreen(BuildContext context, data) {
    pushNextFrame(Container(), context);
  }
}