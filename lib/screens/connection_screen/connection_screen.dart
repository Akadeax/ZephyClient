import 'package:flutter/material.dart';
import 'package:zephy_client/screens/connection_screen/retry_widget.dart';
import 'package:zephy_client/services/nav_wrapper.dart';
import 'package:zephy_client/services/sockets/server_locator.dart';

import '../login_screen/login_screen.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  ServerLocator locator = ServerLocator(6556, 6557);

  Future currentLocateFuture;

  @override
  void initState() {
    currentLocateFuture = locator.locate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(child: _locateBuilder()),
    );
  }

  Widget _locateBuilder() {
    return FutureBuilder(
      future: currentLocateFuture,
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
           pushNextFrame(LoginScreen(snapshot.data), context);
          return Container();
        } else if(snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return RetryWidget(
            onPressed: _retryConnection,
          retryText: "Connection failed!",
        );
      }
    );
  }

  void _retryConnection() {
    currentLocateFuture = locator.locate();
    setState(() {});
  }
}
