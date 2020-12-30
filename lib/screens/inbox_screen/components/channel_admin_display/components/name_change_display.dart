import 'package:flutter/material.dart';

import '../channel_admin_display_logic.dart';

class NameChangeDisplay extends StatelessWidget {

  final ChannelAdminDisplayLogic logic;
  NameChangeDisplay(this.logic);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: logic.nameInputController,
            decoration: InputDecoration(
              labelText: "name",
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: FlatButton(
                child: Text("change"),
                onPressed: logic.onChangeNameButton
            )
        )
      ],
    );
  }
}
