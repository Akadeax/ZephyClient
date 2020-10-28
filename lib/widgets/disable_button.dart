import 'package:flutter/material.dart';

class DisableButton extends StatefulWidget {
  final Widget child;
  final Color enabledColor;
  final Color disabledColor;
  final Function() onPressed;
  DisableButton({
    Key key,
    this.child,
    @required this.enabledColor,
    this.disabledColor,
    @required this.onPressed,
  }) : super(key: key);

  @override
  DisableButtonState createState() => DisableButtonState();
}

class DisableButtonState extends State<DisableButton> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: enabled ? widget.enabledColor : widget.disabledColor,
      onPressed: enabled ? widget.onPressed : null,
      child: widget.child,
    );
  }
}
