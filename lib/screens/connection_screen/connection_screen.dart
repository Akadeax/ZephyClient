import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/screens/connection_screen/components/retry_connection_widget.dart';

import 'connection_screen_logic.dart';

class ConnectionScreen extends StatefulWidget {

  @override
  ConnectionScreenState createState() => ConnectionScreenState();
}

class ConnectionScreenState extends State<ConnectionScreen> {
  ConnectionScreenLogic logic;

  ConnectionScreenState() {
    logic = ConnectionScreenLogic(this);
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<ServerConnection>(context, listen: false));
    return Scaffold(
      body: Center(
        child: logic.locateBuilder(context),
      )
    );
  }

  Widget get loadingWidget {
    return CircularProgressIndicator();
  }

  Widget get retryConnectionWidget {
    return RetryConnectionWidget(logic);
  }

  void update() => setState(() {});
}
