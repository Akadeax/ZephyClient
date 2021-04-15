import 'package:flutter/material.dart';
import 'package:zephy_client/util/controller_view.dart';

class FatalErrorScreen extends StatelessWidget {

  final String fatalErrorText =
"""
A fatal error has occured.
Please consider restarting the app or
contacting an administrator.
""";

  @override
  Widget build(BuildContext context) => _FatalErrorScreenView(this);
}


class _FatalErrorScreenView extends StatelessView<FatalErrorScreen> {
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
                color: theme.colorScheme.secondary,
              ),
            ),
            SizedBox(height: 15),
            Text(
              widget.fatalErrorText,
              style: theme.textTheme.subtitle1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}