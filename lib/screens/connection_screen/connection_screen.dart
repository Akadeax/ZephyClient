import 'package:flutter/material.dart';
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
        body: Center(
          child: _locateBuilder(),
        )
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

        return _retryWidget();
      }
    );
  }

  Widget _retryWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("failed"),
        SizedBox(height: 10),
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
    currentLocateFuture = locator.locate();
    setState(() {});
  }
}
