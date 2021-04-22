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

  LoginForm({Key key}) : super(key: key);

  @override
  LoginFormController createState() => LoginFormController();
}

class LoginFormController extends State<LoginForm> {

  @override
  Widget build(BuildContext context) => LoginFormView(this);

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<LoadingButtonController> loginButton = GlobalKey();

  String identifier;
  String password;

  String identifierValidator(String newVal) {
    if(newVal == null || newVal.isEmpty) {
      return "Please enter a valid identifier";
    }
    return null;
  }

  String passwordValidator(String newVal) {
    if(newVal == null || newVal.isEmpty || newVal.length < 5) {
      return "Please enter a valid password.";
    }
    return null;
  }

  void attemptLogin(BuildContext context, SnackBar wrongLogin) async {
    if(formKey.currentState.validate()) {
      loginButton.currentState.isDisabled = true;
      var attempt = LoginAttemptPacket(LoginAttemptPacketData(
        identifier: identifier,
        password: password,
      ));

      ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
      conn.sendPacket(attempt);

      LoginResponsePacketData response = (await conn.packetHandler.waitForPacket(
          LoginResponsePacket.TYPE,
          (buffer) => LoginResponsePacket.fromBuffer(buffer),
      )).readPacketData();

      await Future.delayed(const Duration(seconds: 1));

      if(response.httpStatus == HttpStatus.unauthorized) {
        loginButton.currentState.isDisabled = false;

        ScaffoldMessengerState msg = ScaffoldMessenger.of(context);
        msg.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
        msg.showSnackBar(wrongLogin);
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
      onPressed: () => controller.attemptLogin(context, wrongLoginSnackbar(context)),
      child: Text("LOG IN"),
    );
  }

  SnackBar wrongLoginSnackbar(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SnackBar(
      content: Text(
        "Wrong login data!",
        style: theme.textTheme.subtitle2.copyWith(
          color: theme.colorScheme.onError
        ),
      ),
      backgroundColor: theme.colorScheme.error,
    );
  }
}
