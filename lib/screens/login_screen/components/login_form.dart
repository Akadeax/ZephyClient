import 'package:flutter/material.dart';
import 'package:zephy_client/app/color_sets.dart';
import 'package:zephy_client/app/text_styles.dart';
import 'package:zephy_client/screens/login_screen/login_screen_logic.dart';
import 'package:zephy_client/widgets/disable_button.dart';

class LoginForm extends StatefulWidget {
  final LoginScreenLogic logic;
  LoginForm(this.logic);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.logic.loginFormKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          emailField(),
          passwordField(),
          loginButton(),
          debugAdminButton(),
        ],
      )
    );
  }

  Widget emailField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        onChanged: (String newVal) => widget.logic.currEmail = newVal,
        validator: widget.logic.emailValidator,
        decoration: InputDecoration(
          labelText: "E-Mail",
          hintText: "Enter your E-Mail",
          suffixIcon: Icon(Icons.email),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        onChanged: (String newVal) => widget.logic.currEmail = newVal,
        validator: widget.logic.passwordValidator,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          suffixIcon: Icon(Icons.security_outlined),
        ),
      ),
    );
  }

  Widget loginButton() {
    return DisableButton(
      key: widget.logic.loginButton,
      enabledColor: AppColorSets.colorPrimaryBlue,
      disabledColor: AppColorSets.colorDisabledButton,
      child: Text(
        LoginScreenAppData.loginButtonText,
        style: AppTextStyles.buttonLabelStyle,
      ),
      onPressed: widget.logic.tryLogin,
    );
  }

  // TODO: remove
  Widget debugAdminButton() {
    return FlatButton(
      child: Text(
        "admin",
        style: AppTextStyles.buttonLabelStyle,
      ),
      onPressed: widget.logic.tryAdminLogin,
    );
  }
}
