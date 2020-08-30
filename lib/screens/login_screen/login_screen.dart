import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/screens/login_screen/sign_in_form.dart';
import 'package:zephy_client/services/server_connection.dart';
import 'package:zephy_client/services/server_locator.dart';

class LoginScreen extends StatefulWidget {

  final BroadcastResult connInfo;

  LoginScreen(this.connInfo);

  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  ServerConnection conn;

  String currEmail = "";
  String currPassword = "";


  @override
  Widget build(BuildContext context) {
    conn = Provider.of<ServerConnection>(context);
    conn.connect(context, widget.connInfo);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SignInForm(),
            ]
        ),
      ),
    );
  }
}
