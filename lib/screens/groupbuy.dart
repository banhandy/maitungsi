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
  }

  void updateUI() {
    categoryStream();
  }

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      setState(() {
        updateUI();
      });
    } catch (e) {
      print(e);
    }
  }

  void categoryStream() async {
    print(logInUser);
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
        onPressed: () {},
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
          List<MaterialButton> categoryListWidget = [];
          final categoryList = snapshot.data.documents.reversed;
          for (var category in categoryList) {
            final MaterialButton categoryButton = MaterialButton(
              child: Text(category.data['category']),
              onPressed: () {},
            );
            categoryListWidget.add(categoryButton);
          }
          return ListWheelScrollView(
            children: categoryListWidget,
            itemExtent: 40.0,
            useMagnifier: true,
            magnification: 1.2,
          );
        });
  }
}
