import 'package:flutter/material.dart';

const kLabelTextStyle = TextStyle(
  fontSize: 30.0,
  color: Color(0xFF8D8E98),
);

const Color kMainColor = Color.fromRGBO(58, 66, 86, 1.0);
const Color kPrimaryColor = Color.fromRGBO(64, 75, 96, .9);
const Color kSecondaryColor = Colors.orangeAccent;

const BoxDecoration kBoxBorderOneSide = BoxDecoration(
    border: Border(right: BorderSide(width: 1.0, color: Colors.white24)));

const TextStyle kMainTextStyle = TextStyle(color: Colors.white, fontSize: 20.0);
const TextStyle kSecondaryTextStyle =
    TextStyle(color: Colors.white, fontSize: 15.0);

const kInputDecoration = InputDecoration(
  labelText: "Enter Password",
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  //fillColor: Colors.green
);
