import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maitungsi/constants.dart';

class MonthlyCard extends StatelessWidget {
  final double value;
  final int month;
  final int year;
  final Function onPress;

  final f = NumberFormat("#,###.0#", "en_US");

  MonthlyCard({this.month, this.year, this.value, this.onPress});

  String generateMonth(int month) {
    String monthName = '';
    switch (month) {
      case (1):
        {
          monthName = 'JAN';
        }
        break;
      case (2):
        {
          monthName = 'FEB';
        }
        break;
      case (3):
        {
          monthName = 'MAR';
        }
        break;
      case (4):
        {
          monthName = 'APR';
        }
        break;
      case (5):
        {
          monthName = 'MAY';
        }
        break;
      case (6):
        {
          monthName = 'JUN';
        }
        break;
      case (7):
        {
          monthName = 'JUL';
        }
        break;
      case (8):
        {
          monthName = 'AUG';
        }
        break;
      case (9):
        {
          monthName = 'SEP';
        }
        break;
      case (10):
        {
          monthName = 'OCT';
        }
        break;
      case (11):
        {
          monthName = 'NOV';
        }
        break;
      case (12):
        {
          monthName = 'DEC';
        }
        break;
    }
    return monthName;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Material(
        color: kPrimaryColor,
        child: InkWell(
          onTap: onPress,
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 10.0),
              decoration: kBoxBorderOneSide,
              child: Column(
                children: <Widget>[
                  Text(
                    generateMonth(month),
                    style: kMainTextStyle,
                  ),
                  Text(
                    year.toString(),
                    style: kMainTextStyle,
                  ),
                ],
              ),
            ),
            title: Text(
              f.format(this.value),
              style: kMainTextStyle,
            ),
            trailing:
                Icon(Icons.arrow_forward, color: kSecondaryColor, size: 30.0),
          ),
        ),
      ),
    );
  }
}
