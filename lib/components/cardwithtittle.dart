import 'package:flutter/material.dart';
import 'package:maitungsi/constants.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton({@required this.text, this.onPress});
  final String text;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Material(
          color: kPrimaryColor,
          child: InkWell(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(
                text,
                style: kMainTextStyle,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: kSecondaryColor, size: 30.0),
              onTap: onPress,
            ),
          ),
        ));
  }
}
