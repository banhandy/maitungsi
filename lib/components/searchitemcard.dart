import 'package:flutter/material.dart';
import 'package:maitungsi/constants.dart';

class SearchItemCard extends StatelessWidget {
  SearchItemCard({@required this.text, this.onPress, this.category});
  final String text;
  final Function onPress;
  final String category;
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
              subtitle: Text(
                category,
                style: TextStyle(
                  color: kSecondaryColor,
                  fontStyle: FontStyle.italic,
                  fontSize: 14.0,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: kSecondaryColor, size: 30.0),
              onTap: onPress,
            ),
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
