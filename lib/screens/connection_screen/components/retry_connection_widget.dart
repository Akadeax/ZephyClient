import 'package:flutter/material.dart';
import 'package:zephy_client/app/color_sets.dart';
import 'package:zephy_client/app/text_styles.dart';
import 'package:zephy_client/screens/connection_screen/connection_screen_logic.dart';

class RetryConnectionWidget extends StatelessWidget {
  final double paddingHorizontalAmount = 40;

  final ConnectionScreenLogic logic;

  RetryConnectionWidget(this.logic);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalAmount),
          child: Text(
            ConnectionScreenAppData.connectionFailedText,
            style: AppTextStyles.infoStyle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: ConnectionScreenAppData.retrySeperatorHeight),
        FlatButton(
          color: AppColorSets.colorPrimaryBlue,
          child: Text(
            ConnectionScreenAppData.retryButtonText,
            style: AppTextStyles.buttonLabelStyle,
          ),
          onPressed: logic.onRetryPressed,
        )
      ],
    );
  }
}
