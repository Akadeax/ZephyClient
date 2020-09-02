import 'package:flutter/material.dart';
import 'package:zephy_client/services/nav_wrapper.dart';
import 'package:zephy_client/services/server_locator.dart';

import 'login_screen/login_screen.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  ServerLocator locator = ServerLocator(6556, 6557);

  Future<BroadcastResult> currentLocate;

  bool hasLocatedServer = false;

  _ConnectionScreenState() {
    currentLocate = locator.locate();
  }

  @override
  Widget build(BuildContext context) {
    // try to locate server, if found, go to login

    return Scaffold(
        body: Center(
          child: hasLocatedServer ? Container() : _locateBuilder(),
        )
    );
  }

  FutureBuilder _locateBuilder() {
    return FutureBuilder(
        future: currentLocate,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("error! " + snapshot.error.toString());
          }
          if (snapshot.hasData && snapshot.data != null) {
            hasLocatedServer = true;
            pushNextFrame(LoginScreen(snapshot.data), context);
            return Container();
          }
          else {
            // if locating fails
            return _retryWidget();
          }

        });
  }

  Widget _retryWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("failed"),
        FlatButton(
          color: Colors.blueAccent,
          child: Text(
            "retry",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _retryConnection
        )
      ],
    );
  }

  void _retryConnection() {
    currentLocate = locator.locate();
    setState(() {});
  }
}
