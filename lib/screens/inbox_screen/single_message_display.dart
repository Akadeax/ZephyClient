import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'package:zephy_client/services/style_presets.dart';

class SingleMessageDisplay extends StatelessWidget {

  final PopulatedMessage toDisplay;
  SingleMessageDisplay(this.toDisplay);


  @override
  Widget build(BuildContext context) {
    ProfileData _profileData = Provider.of<ProfileData>(context);

    bool isAuthor = _profileData.loggedInUser.sId == toDisplay.author.sId;
    Color messageColor = isAuthor ? Colors.blue[300] : Colors.grey;

    DateTime time = DateTime.fromMillisecondsSinceEpoch((toDisplay.sentAt * 1000).round(), isUtc: true);

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          decoration: new BoxDecoration(
            color: messageColor,
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${toDisplay.author.name} at ${time.toString()}",
                  style: StylePresets.messageTitleStyle,
                ),
                Text(
                  "${toDisplay.content}",
                  style: StylePresets.messageContentStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
