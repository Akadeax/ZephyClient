import 'package:flutter/material.dart';
import 'package:zephy_client/app/text_styles.dart';

class FatalErrorScreenAppData {
  static const String errorMessage = "A fatal error has occured.";
}

class FatalErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Center(
          child: Text(
            FatalErrorScreenAppData.errorMessage,
            style: AppTextStyles.infoStyle,
          ),
        )
      )
    );
  }
}
