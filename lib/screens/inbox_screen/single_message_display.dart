import 'package:flutter/material.dart';
import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/services/style_presets.dart';

class SingleMessageDisplay extends StatelessWidget {

  final PopulatedMessage toDisplay;
  SingleMessageDisplay(this.toDisplay);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "${toDisplay.author.name}: ${toDisplay.content}",
              style: StylePresets.messageStyle,
            ),
          ),
        ),
      ),
    );
  }
}
