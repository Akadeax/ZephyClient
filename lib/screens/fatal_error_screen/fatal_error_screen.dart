import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zephy_client/screens/connection_screen/retry_widget.dart';

class FatalErrorScreen extends StatelessWidget {
  final String displayError;

  FatalErrorScreen({this.displayError});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RetryWidget(
          retryText:
          """
          Something has went fatally wrong. We apologize for any inconveniences caused by this. error:
          $displayError
          """,
          buttonText: "close app",
          onPressed: () {
            exit(0);
          },
        )
      )
    );
  }
}
