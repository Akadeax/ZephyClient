import 'package:flutter/material.dart';

class SendMessageDisplay extends StatefulWidget {
  @override
  _SendMessageDisplayState createState() => _SendMessageDisplayState();
}

class _SendMessageDisplayState extends State<SendMessageDisplay> {

  String currMessage = "";

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 50,
      color: Colors.blue,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: size.width / 2,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Message",
                ),
              ),
            ),
            FlatButton(
              child: Text(
                "send",
              ),
              color: Colors.greenAccent,
              onPressed: () {
                if(_controller.text.isEmpty) return;
              },
            ),
          ],
        )
      )
    );
  }
}
