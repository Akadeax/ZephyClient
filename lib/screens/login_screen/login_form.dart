import 'dart:io';

import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/error_snack_bar.dart';
import 'package:zephy_client/components/loading_button.dart';
import 'package:zephy_client/providers/profile_handler.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/screens/login_screen/login_field.dart';
import 'package:zephy_client/services/networking/packet/auth/login_attempt_packet.dart';
import 'package:zephy_client/services/networking/packet/auth/login_response_packet.dart';
import 'package:zephy_client/util/nav_util.dart';

class LoginForm extends StatefulWidget {

  final String alreadyLoggedInError = "That account is already logged in!";
  final String invalidLoginError = "Invalid Login data!";

  LoginForm({Key key}) : super(key: key);

  @override
  LoginFormController createState() => LoginFormController();
}

class LoginFormController extends State<LoginForm> {

  @override
  Widget build(BuildContext context) => LoginFormView(this);

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<LoadingButtonController> loginButton = GlobalKey();

  String identifier = "";
  String password = "";

  String identifierValidator(String newVal) {
    if(newVal == null || newVal.isEmpty) {
      return "Please enter a valid identifier";
    }
    return null;
  }

  String passwordValidator(String newVal) {
    if(newVal == null || newVal.isEmpty) {
      return "Please enter a valid password";
    }
    return null;
  }

  void attemptLogin(BuildContext context) async {
    if(formKey.currentState.validate()) {
      loginButton.currentState.isDisabled = true;

      String pwh = Crypt.sha512(password, salt: "zephy").toString();

      var attempt = LoginAttemptPacket(LoginAttemptPacketData(
        identifier: identifier,
        password: pwh,
      ));

      ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
      conn.sendPacket(attempt);

      LoginResponsePacketData response = (await conn.packetHandler.waitForPacket<LoginResponsePacket>(
          LoginResponsePacket.TYPE,
          (buffer) => LoginResponsePacket.fromBuffer(buffer),
      )).readPacketData();

      await Future.delayed(const Duration(seconds: 1));

      switch(response.httpStatus) {
        case HttpStatus.unauthorized:
          loginButton.currentState.isDisabled = false;
          showErrorSnackBar(context, "Your identifier or password is incorrect!");
          break;

        case HttpStatus.forbidden:
          loginButton.currentState.isDisabled = false;
          showErrorSnackBar(context, "That user is already logged in!");
          break;

        case HttpStatus.ok:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          print("SETTING IN PREFS: ${response.accessToken}");
          prefs.setString("accessToken", response.accessToken);

          Provider.of<ProfileHandler>(context, listen: false).user = response.user;
          rootNavPush("/inbox");
      }
    }
  }
}


class LoginFormView extends StatefulWidgetView<LoginForm, LoginFormController> {
  LoginFormView(LoginFormController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: Form(
        key: controller.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildIdentifierField(context),
            buildPasswordField(context),
            SizedBox(height: 10),
            buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  buildIdentifierField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: LoginField(
        onChanged: (val) => controller.identifier = val,
        validator: controller.identifierValidator,
        hintText: "Identifier...",
        labelText: "Username or E-Mail",
      ),
    );
  }

  buildPasswordField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: LoginField(
        isPasswordField: true,
        onChanged: (val) => controller.password = val,
        validator: controller.passwordValidator,
        labelText: "Password",
        hintText: "Enter Password...",
      ),
    );
  }

  buildLoginButton(BuildContext context) {
    return LoadingButton(
      key: controller.loginButton,
      onPressed: () => controller.attemptLogin(context),
      child: Text("LOG IN"),
    );
  }
}
