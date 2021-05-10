import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessengerState msg = ScaffoldMessenger.of(context);
  msg.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
  msg.showSnackBar(_getSnackBar(context, message));
}

SnackBar _getSnackBar(BuildContext context, String message) {
  ThemeData theme = Theme.of(context);
  return SnackBar(
    backgroundColor: theme.errorColor,
    content: Text(
      message,
      style: theme.textTheme.bodyText1,
    ),
  );
}