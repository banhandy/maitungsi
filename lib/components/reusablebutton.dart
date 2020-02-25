import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton({@required this.colour, this.text, this.onPress});
  final Color colour;
  final String text;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.white, size: 30.0),
            onTap: onPress,
          ),
        ));
  }
}

//return MaterialButton(
//elevation: 10.0,
//onPressed: onPress,
//child: Container(
//child: Center(
//child: Text(
//text,
//style: kLabelTextStyle,
//),
//),
//margin: EdgeInsets.all(5.0),
//padding: EdgeInsets.all(20.0),
//decoration: BoxDecoration(
//borderRadius: BorderRadius.circular(2.0),
//color: colour,
//),
//),
//);
