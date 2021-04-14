import 'package:flutter/material.dart';
import 'package:zephy_client/networking/server_locator.dart';
import 'package:zephy_client/screens/login_screen/login_screen.dart';
import 'package:zephy_client/utils/nav_util.dart';

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
    return FutureBuilder(
      future: currentLocateFuture,
      builder: (ctx, snapshot) {

        bool dataIsValid = !snapshot.hasError && snapshot.data != null;
        bool isLoading = snapshot.connectionState == ConnectionState.waiting;

        // Server Location was successful
        if(dataIsValid && !isLoading) {
          pushNextFrame(LoginScreen(snapshot.data), context);
        }

        bool showError = !dataIsValid && !isLoading;

        return AnimatedCrossFade(
          duration: screen.fadeToError,
          reverseDuration: screen.fadeFromError,

          firstChild: screen.loading(),
          secondChild: screen.error(),

          crossFadeState: showError ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          layoutBuilder: fadeLayoutBuilder,
        );
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

  Widget fadeLayoutBuilder(top, topKey, bottom, bottomKey) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          key: bottomKey,
          child: bottom,
        ),
        Positioned(
          key: topKey,
          child: top,
        ),
      ],
    );
  }
}