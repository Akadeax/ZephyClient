import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/loading_button.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/screens/login_screen/login_field.dart';
import 'package:zephy_client/services/networking/packet/auth/login_attempt_packet.dart';
import 'package:zephy_client/services/networking/packet/auth/login_response_packet.dart';

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

  void attemptLogin(
      BuildContext context,
      SnackBar Function(BuildContext, String) errorSnackBar
  ) async {
    if(formKey.currentState.validate()) {
      loginButton.currentState.isDisabled = true;
      var attempt = LoginAttemptPacket(LoginAttemptPacketData(
        identifier: identifier,
        password: password,
      ));

      ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
      conn.sendPacket(attempt);

      LoginResponsePacketData response = (await conn.packetHandler.waitForPacket<LoginResponsePacket>(
          LoginResponsePacket.TYPE,
          (buffer) => LoginResponsePacket.fromBuffer(buffer),
      )).readPacketData();

      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessengerState msg = ScaffoldMessenger.of(context);

      switch(response.httpStatus) {
        case HttpStatus.unauthorized:
          loginButton.currentState.isDisabled = false;

          msg.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
          msg.showSnackBar(errorSnackBar(context, "Your identifier or password is incorrect!"));
          break;

        case HttpStatus.forbidden:
          loginButton.currentState.isDisabled = false;

          msg.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
          msg.showSnackBar(errorSnackBar(context, "That user is already logged in!"));
          break;

        case HttpStatus.ok:
          print("Login successful!");
          // TODO: Push inbox screen with response.user
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
            identifierField(context),
            passwordField(context),
            SizedBox(height: 10),
            loginButton(context),
          ],
        ),
      ),
    );
  }

  Widget identifierField(BuildContext context) {
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

  Widget passwordField(BuildContext context) {
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

  Widget loginButton(BuildContext context) {
    return LoadingButton(
      key: controller.loginButton,
      onPressed: () => controller.attemptLogin(context, errorSnackBar),
      child: Text("LOG IN"),
    );
  }

  SnackBar errorSnackBar(BuildContext context, String message) {
    return SnackBar(content: Text(message));
  }
}
