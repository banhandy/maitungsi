import 'package:flutter/material.dart';
import 'package:maitungsi/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupBuy extends StatefulWidget {
  static String id = 'Group Buy';
  @override
  _GroupBuyState createState() => _GroupBuyState();
}

class _GroupBuyState extends State<GroupBuy> {
  String logInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    categoryStream();
  }

  void categoryStream() async {
    await for (var snapshot
        in Firestore.instance.collection('categories').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Buy List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove('email');
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          )
        ],
      ),
      body: Text('Welcome $logInUser'),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
