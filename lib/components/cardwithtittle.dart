import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton({@required this.text, this.onPress});
  final String text;
  final Function onPress;
  //String category = '';
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Material(
          color: Color.fromRGBO(64, 75, 96, .9),
          child: InkWell(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0),
              onTap: onPress,
            ),
          ),
        ));
  }
}
