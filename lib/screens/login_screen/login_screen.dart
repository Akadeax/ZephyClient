import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/providers/server_connection.dart';
import 'package:zephy_client/providers/server_locator.dart';
import 'package:zephy_client/screens/login_screen/login_form.dart';


class LoginScreen extends StatefulWidget {
  final String invalidEmailError = "Please enter a valid E-Mail!";
  final String invalidPasswordError = "Please enter a valid Password!";

  final String invalidLoginText = "Your login data was invalid!";

  final String noAccountButtonText = "Don't have an account?";
  final String accountHelpTitle = "I don't have login data?";
  final String accountHelpContent = "Zephy operates on the local network. Please notify the company or institution that hosts this instance of Zephy that you require an account.";

  @override
  _LoginScreenController createState() => _LoginScreenController();
}

class _LoginScreenController extends State<LoginScreen> {
  GlobalKey<LoginFormController> loginForm = GlobalKey();

  @override
  void initState() {
    ServerLocator loc = Provider.of<ServerLocator>(context, listen: false);
    ServerConnection conn = Provider.of<ServerConnection>(context, listen: false);
    if(!conn.isConnected) {
      conn.connect(loc.lastBroadcastResult);
    }

    super.initState();
  }

  void needAccountPressed(BuildContext context) {
    showOkAlertDialog(
      context: context,
      title: widget.accountHelpTitle,
      message: widget.accountHelpContent,
    );
  }

  @override
  Widget build(BuildContext context) => _LoginScreenView(this);
}

class _LoginScreenView extends StatefulWidgetView<LoginScreen, _LoginScreenController> {
  _LoginScreenView(_LoginScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 7, child: Container()),
            Expanded(
              flex: 4,
              child: Text(
                "Sign in",
                textAlign: TextAlign.center,
                style: theme.textTheme.headline4.copyWith(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 13,
              child: LoginForm(
                key: controller.loginForm,
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: TextButton(
                  onPressed: () => controller.needAccountPressed(context),
                  child: Text(
                    widget.noAccountButtonText,
                    style: theme.textTheme.bodyText2.copyWith(
                      color: theme.colorScheme.primaryVariant,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            ),
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: CircleDecorationPainter(
                      theme: Theme.of(context)
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}

class CircleDecorationPainter extends CustomPainter {
  final ThemeData theme;
  CircleDecorationPainter({@required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = theme.colorScheme.secondary;
    canvas.drawCircle(Offset(0, size.height * 0.8), 100, paint);
    paint.color = theme.colorScheme.secondaryVariant;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 1.5), 100, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}