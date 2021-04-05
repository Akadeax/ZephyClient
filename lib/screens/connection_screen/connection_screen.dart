import 'package:flutter/material.dart';
import 'package:zephy_client/widgets/loading/loading.dart';

import 'connection_screen_logic.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  ConnectionScreenState createState() => ConnectionScreenState();
}


class ConnectionScreenState extends State<ConnectionScreen> {
  Duration fadeToError = const Duration(milliseconds: 200);
  Duration fadeFromError = const Duration(milliseconds: 75);


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

  Widget loading([List<Color> colors]) {
    return Loading(singleBallSize: 25, colors: colors == null ? loadingColors : colors);
  }

  Widget error() {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          loading(errorColors),
          Positioned(
              top: size.height / 2 + 60,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Text(
                    "A valid server could not be located on your network.",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    child: Text("Retry Connection"),
                    onPressed: logic.onRetryPressed,
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  void rebuild() {
    setState(() {});
  }
}
