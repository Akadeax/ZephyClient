import 'package:flutter/material.dart';

void showErrorSnackBar(String message, BuildContext context) {
  var state = ScaffoldMessenger.of(context);

  state.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
  state.showSnackBar(errorSnackBar(context, message));
}



SnackBar errorSnackBar(BuildContext context, String message) {
  ThemeData theme = Theme.of(context);

  return SnackBar(
    backgroundColor: theme.errorColor,
    content: Text(
      message,
      style: theme.textTheme.bodyText1.copyWith(
        color: theme.colorScheme.onError,
      ),
    ),
  );
}