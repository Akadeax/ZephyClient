import 'package:flutter/material.dart';
import 'package:zephy_client/models/message_model.dart';

class SingleMessageDisplay extends StatelessWidget {

  final PopulatedMessage toDisplay;
  SingleMessageDisplay(this.toDisplay);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Text(
        "${toDisplay.author.name}: ${toDisplay.content}",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
