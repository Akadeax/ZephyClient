import 'package:flutter/material.dart';
import 'package:zephy_client/widgets/loading/loading.dart';

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
    return Scaffold(
      body: Center(
          child: logic.locateWidget(context),
      ),
    );
  }

  Widget loading() {
    return Loading(singleBallSize: 25);
  }

  void rebuild() {
    setState(() {});
  }
}
