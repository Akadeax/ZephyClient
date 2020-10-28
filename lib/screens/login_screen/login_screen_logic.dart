import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/app/text_styles.dart';
import 'package:zephy_client/networking/server_connection.dart';
import 'package:zephy_client/packet/auth/login_attempt_packet.dart';
import 'package:zephy_client/packet/auth/login_result_packet.dart';
import 'package:zephy_client/packet/packet_wait.dart';
import 'package:zephy_client/utils/validator.dart';
import 'package:zephy_client/widgets/disable_button.dart';

import 'login_screen.dart';

class LoginScreenAppData {
  static const String invalidEmailError = "Please enter a valid E-Mail!";
  static const String invalidPasswordError = "Please enter a valid Password!";

  static const String loginButtonText = "Login";

  static const String invalidLoginText = "Your login data was invalid!";
}

class LoginScreenLogic {

  LoginScreenState screen;
  LoginScreenLogic(this.screen);

  PacketWait loginResponseWait = PacketWait<LoginResultPacket>(LoginResultPacket.TYPE, (buffer) => LoginResultPacket.fromBuffer(buffer));

  GlobalKey<FormState> loginFormKey = GlobalKey();
  GlobalKey<DisableButtonState> loginButton = GlobalKey();


  String currEmail, currPassword;

  Future<void> tryLogin() async {
    ServerConnection conn = Provider.of<ServerConnection>(loginFormKey.currentContext, listen: false);
    loginFormKey.currentState.save();
    var packet = LoginAttemptPacket(LoginAttemptPacketData(
      email: currEmail,
      password: currPassword
    ));
    conn.sendPacket(packet);

    loginResponseWait.startWait(conn, (packet) {
      LoginResultPacketData data = packet.readPacketData();
      if(data.statusCode == HttpStatus.ok) {
        // TODO: Push inbox
        print("Right login! ${data.user}");
      } else {
        print("wrong login!");
        ScaffoldState scaff = Scaffold.of(loginFormKey.currentContext);
        scaff.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
        scaff.showSnackBar(
          screen.wrongLoginSnackbar()
        );
      }
    });
  }

  Future<void> tryAdminLogin() async {
    currEmail = "admin@admin.com";
    currPassword = "admin";
    tryLogin();
  }

  String emailValidator(String val) {
    if(!isValidEmail(val) || val == "") {
      return LoginScreenAppData.invalidEmailError;
    }
    return null;
  }

  String passwordValidator(String val) {
    if(!isValidPassword(val) || val == "") {
      return LoginScreenAppData.invalidPasswordError;
    }
    return null;
  }


}