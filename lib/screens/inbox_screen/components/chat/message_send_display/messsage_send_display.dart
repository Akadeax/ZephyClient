import 'package:flutter/material.dart';
import 'package:zephy_client/app/color_sets.dart';
import 'package:zephy_client/app/text_styles.dart';

import 'message_send_display_logic.dart';

class MessageSendDisplay extends StatefulWidget {
  @override
  MessageSendDisplayState createState() => MessageSendDisplayState();
}

class MessageSendDisplayState extends State<MessageSendDisplay> {
  MessageSendDisplayLogic logic;
  MessageSendDisplayState() {
    logic = MessageSendDisplayLogic(this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: ColorSets.primaryLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            width: size.width / 3,
            child: TextField(
              controller: logic.controller,
              decoration: InputDecoration(
                hintText: "Message...",
              ),
              onSubmitted: (_) =>  logic.sendMessage(context),
              textInputAction: TextInputAction.send,
              focusNode: logic.controllerNode,
            ),
          ),
          Container(
            width: size.width / 7,
            child: FlatButton(
              child: Text(
                "send",
                style: AppTextStyles.buttonLabelStyle
              ),
              color: ColorSets.primaryDark,
              onPressed: () => logic.sendMessage(context),
            ),
          )
        ],
      )
    );
  }
}
