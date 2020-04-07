import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maitungsi/constants.dart';

class ItemCard extends StatelessWidget {
  final double value;
  final double quantity;
  final Timestamp date;
  final Function onPress;

  final f = NumberFormat("#,###.0#", "en_US");

  ItemCard({this.date, this.quantity, this.value, this.onPress});

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
      child: Container(
        decoration: BoxDecoration(color: kPrimaryColor),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 10.0),
            decoration: kBoxBorderOneSide,
            child: Column(
              children: <Widget>[
                Text(
                  date.toDate().day.toString() +
                      ' ' +
                      generateMonth(date.toDate().month),
                  style: kMainTextStyle,
                ),
                Text(
                  date.toDate().year.toString(),
                  style: kMainTextStyle,
                ),
              ],
            ),
          ),
          title: Text(
            f.format(this.value),
            style: kMainTextStyle,
          ),
          subtitle: Row(
            children: <Widget>[
              Icon(Icons.shopping_cart, color: kSecondaryColor),
              SizedBox(
                width: 20.0,
              ),
              Text(
                this.quantity.toInt().toString(),
                style: kMainTextStyle,
              ),
            ],
          ),
          trailing: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Icon(Icons.delete, color: Colors.redAccent, size: 30.0),
              onTap: onPress,
            ),
          ),
        ),
      ),
    );
  }
}
