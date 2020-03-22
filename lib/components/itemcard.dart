import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final double value;
  final double quantity;
  final Timestamp date;
  final Function onPress;

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
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 10.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Column(
              children: <Widget>[
                Text(
                  date.toDate().day.toString() +
                      ' ' +
                      generateMonth(date.toDate().month),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0),
                ),
                Text(
                  date.toDate().year.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ],
            ),
          ),
          title: Text(
            this.value.toInt().toString(),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          ),
          subtitle: Row(
            children: <Widget>[
              Icon(Icons.shopping_cart, color: Colors.yellowAccent),
              SizedBox(
                width: 20.0,
              ),
              Text(
                this.quantity.toInt().toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          trailing: GestureDetector(
            child: Icon(Icons.delete, color: Colors.white, size: 30.0),
            onTap: onPress,
          ),
        ),
      ),
    );
  }
}
