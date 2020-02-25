import 'package:flutter/material.dart';
import 'package:maitungsi/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitungsi/components/reusablebutton.dart';
import 'dart:math';

class GroupBuy extends StatefulWidget {
  static String id = 'Group Buy';

  @override
  _GroupBuyState createState() => _GroupBuyState();
}

class _GroupBuyState extends State<GroupBuy> {
  String logInUser;
  String categoryInput;

  TextEditingController _textFieldController = TextEditingController();
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            title: Text(
              'Add Category',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: _textFieldController,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                categoryInput = value;
              },
              decoration: InputDecoration(hintText: "Category"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  _textFieldController.clear();
                  Firestore.instance
                      .collection('categories')
                      .document()
                      .setData({'category': categoryInput, 'email': logInUser});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      setState(() {
        // updateUI();
      });
    } catch (e) {
      print(e);
    }
  }

  void categoryStream() async {
    await for (var snapshot in Firestore.instance
        .collection('categories')
        .where("email", isEqualTo: logInUser)
        .snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
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
      body: CategoryList(logInUser),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        onPressed: () {
          _displayDialog(context);
        },
      ),
      bottomNavigationBar: Container(
        height: 55.0,
        child: BottomAppBar(
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.blur_on, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.hotel, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.account_box, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final String logInUser;
  CategoryList(this.logInUser);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('categories')
            .where("email", isEqualTo: logInUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          List<ReusableButton> categoryListWidget = [];
          final categoryList = snapshot.data.documents.reversed;
          for (var category in categoryList) {
            final ReusableButton categoryButton = ReusableButton(
              colour:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              text: category.data['category'],
              onPress: () {},
            );
            categoryListWidget.add(categoryButton);
          }
          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: categoryListWidget,
          );
        });
  }
}
