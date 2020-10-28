import 'package:flutter/material.dart';
import 'package:zephy_client/app/text_styles.dart';
import 'package:zephy_client/networking/server_locator.dart';
import 'package:zephy_client/screens/login_screen/login_screen_logic.dart';

import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  final BroadcastResult connectionData;
  LoginScreen(this.connectionData);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  LoginScreenLogic logic;
  LoginScreenState() {
    logic = LoginScreenLogic(this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: LoginForm(logic),
      ),
    );
  }

  SnackBar wrongLoginSnackbar() {
    return SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        LoginScreenAppData.invalidLoginText,
        style: AppTextStyles.snackbarStyle,
      ),
    );
  }
}
