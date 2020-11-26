import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/app/text_styles.dart';
import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/prov/current_login_user.dart';

class SingleMessageDisplay extends StatelessWidget {
  final PopulatedMessage toDisplay;
  SingleMessageDisplay(this.toDisplay);

  @override
  Widget build(BuildContext context) {
    CurrentLoginUser user = Provider.of<CurrentLoginUser>(context);

    bool isAuthor = user.user.sId == toDisplay.author.sId;
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
                  style: AppTextStyles.singleMessageAuthorStyle
                ),
                Text(
                  "${toDisplay.content}",
                  style: AppTextStyles.singleMessageTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
