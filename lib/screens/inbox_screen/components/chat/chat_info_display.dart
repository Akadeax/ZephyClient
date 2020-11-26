import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/app/color_sets.dart';
import 'package:zephy_client/app/text_styles.dart';
import 'package:zephy_client/prov/current_display_channel.dart';

class ChatInfoDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CurrentDisplayChannel channel = Provider.of<CurrentDisplayChannel>(context);

    return Container(
      color: AppColorSets.colorPrimaryDarkBlue,
      child: Center(
        child: Text(
          channel.baseChannelData.name ?? "",
          style: AppTextStyles.chatInfoDisplayStyle
        ),
      ),
    );
  }
}
