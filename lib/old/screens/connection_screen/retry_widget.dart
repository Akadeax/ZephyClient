import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  final String retryText;
  final String buttonText;
  final Function onPressed;

  RetryWidget({this.onPressed, this.retryText, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(retryText ?? "retry"),
        SizedBox(height: 5),
        FlatButton(
            color: Colors.blueAccent,
            child: Text(
              buttonText ?? "retry",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onPressed
        )
      ],
    );
  }
}
