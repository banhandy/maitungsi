import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final Color buttonColor;

  RoundButton({this.buttonColor, this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: buttonColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
