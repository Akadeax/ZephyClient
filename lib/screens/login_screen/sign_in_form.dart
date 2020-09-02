import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/packet/auth/login_attempt_packet.dart';
import 'package:zephy_client/packet/auth/login_result_packet.dart';
import 'package:zephy_client/screens/login_screen/wrong_login_snackbar.dart';
import 'package:zephy_client/services/nav_wrapper.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/server_connection.dart';
import 'package:zephy_client/services/validator.dart';

import '../inbox_screen/inbox_screen.dart';
import 'login_button.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm> {

  final _formKey = GlobalKey<FormState>();

  ServerConnection _conn;
  ProfileData _profileData;

  String email;
  String password;

  GlobalKey<LoginButtonState> loginBtnKey = GlobalKey<LoginButtonState>();

  @override
  Widget build(BuildContext context) {
    _conn = Provider.of<ServerConnection>(context);
    _profileData = Provider.of<ProfileData>(context);

    return Form(
      key: _formKey,
      autovalidate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildEmailField(context),
          SizedBox(height: 30),
          buildPasswordField(context),
          SizedBox(height: 30),
          LoginButton(
            key: loginBtnKey,
            onPressed: () async {
              if(!_formKey.currentState.validate()) return;

              loginBtnKey.currentState.disableButton();

              _formKey.currentState.save();
              LoginAttemptPacket packet = new LoginAttemptPacket(LoginAttemptPacketData(
                  email: email,
                  password: password
              ));

              _conn.sendPacket(packet);

              LoginResultPacket result = await _conn.waitForPacket<LoginResultPacket>((buffer) => LoginResultPacket.fromBuffer(buffer));
              LoginResultPacketData data = result.readPacketData();

              switch(data.statusCode) {
                case HttpStatus.ok:
                  _profileData.loggedInUser = data.user;
                  pushNextFrame(InboxScreen(), context); break;
                default:
                  ScaffoldState curr = Scaffold.of(context);
                  curr.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
                  curr.showSnackBar(wrongLoginSnackBar());
                  loginBtnKey.currentState.enableButton();
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildEmailField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (newVal) => email = newVal,
        validator: (value) {
          // if no value entered (= ""), display now error
          if(value.isEmpty) return null;
          else if(!isValidEmail(value)) {
            return "Please enter a valid E-Mail address.";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "Enter your E-Mail",
          suffixIcon: Icon(Icons.email),
        ),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        obscureText: true,
        onSaved: (newVal) => password = newVal,
        onChanged: (value) {

        },
        validator: (value) {
          if(value.isEmpty) return null;
          else if(!isValidPassword(value)) {
            return "Your password may not contain special characters.";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "password",
          hintText: "Enter your Password",
        ),
      ),
    );
  }
}
