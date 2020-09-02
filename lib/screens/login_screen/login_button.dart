import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final Function onPressed;

  LoginButton({Key key, this.onPressed}) : super(key: key);

  @override
  LoginButtonState createState() => LoginButtonState();
}

class LoginButtonState extends State<LoginButton> {

  bool isDisabled = false;

   @override
   Widget build(BuildContext context) {

     Color btnColor = isDisabled ? Colors.grey[800] : Colors.blueAccent;

     return FlatButton(
       child: Text(
         "Login",
         style: TextStyle(color: Colors.white),
       ),
       color: btnColor,
       onPressed: isDisabled ? () {} : widget.onPressed,
     );
   }

   void disableButton() {
     if(isDisabled) return;
     setState(() {
       isDisabled = true;
     });
   }

  void enableButton() {
    if(!isDisabled) return;
    setState(() {
      isDisabled = false;
    });
  }
}
