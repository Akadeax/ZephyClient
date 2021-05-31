import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';

class FatalErrorScreen extends StatelessWidget {

  final String error;
  FatalErrorScreen(this.error);

  final String fatalErrorText =
"""
A fatal error has occured.
Please consider restarting the app or
contacting an administrator.
Error: 
""";

  @override
  Widget build(BuildContext context) => _FatalErrorScreenView(this);
}


class _FatalErrorScreenView extends StatelessWidgetView<FatalErrorScreen> {
  const _FatalErrorScreenView(FatalErrorScreen widget) : super(widget);

  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ":(",
              style: theme.textTheme.headline1.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 40),
            Text(
              controller.fatalErrorText + controller.error,
              style: theme.textTheme.subtitle1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}