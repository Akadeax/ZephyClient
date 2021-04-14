import 'package:flutter/material.dart';
import 'package:zephy_client/networking/server_locator.dart';
import 'package:zephy_client/widgets/zephy_logo.dart';

class LoginScreen extends StatefulWidget {
  final BroadcastResult connectionData;
  LoginScreen(this.connectionData);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ZephyLogo(
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      )
    );
  }
}
