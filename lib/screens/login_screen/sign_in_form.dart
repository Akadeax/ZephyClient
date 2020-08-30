import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/packet/auth/login_attempt_packet.dart';
import 'package:zephy_client/services/server_connection.dart';
import 'package:zephy_client/services/validator.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm> {
  ServerConnection conn;

  final formKey = GlobalKey<FormState>();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    conn = Provider.of<ServerConnection>(context);

    return Form(
      key: formKey,
      autovalidate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildEmailField(context),
          SizedBox(height: 30),
          buildPasswordField(context),
          SizedBox(height: 30),
          FlatButton(
            child: Text("Login"),
            color: Colors.grey,
            onPressed: () {
              if(formKey.currentState.validate()) {
                formKey.currentState.save();
                LoginAttemptPacket packet = new LoginAttemptPacket(LoginAttemptPacketData(
                  email: email,
                  password: password
                ));

                conn.sendPacket(packet);
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
