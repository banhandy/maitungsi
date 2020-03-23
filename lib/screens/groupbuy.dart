import 'package:flutter/material.dart';
import 'package:maitungsi/screens/detailtungsi.dart';
import 'package:maitungsi/screens/login.dart';
import 'package:maitungsi/screens/searchitem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitungsi/components/reusablebutton.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GroupBuy extends StatefulWidget {
  static String id = 'Group Buy';

  @override
  _GroupBuyState createState() => _GroupBuyState();
}

class _GroupBuyState extends State<GroupBuy> {
  String logInUser;
  String categoryInput;

  TextEditingController _textFieldController = TextEditingController();

  void showAddCategory() {
    Alert(
        context: context,
        title: "Add Category",
        content: Column(
          children: <Widget>[
            TextField(
              controller: _textFieldController,
              onChanged: (value) {
                categoryInput = value;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.assignment),
                labelText: 'Category',
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (categoryInput != null && categoryInput != '') {
                _textFieldController.clear();
                Firestore.instance
                    .collection('categories')
                    .document()
                    .setData({'category': categoryInput, 'email': logInUser});
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

//

  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void categoryStream() async {
    await for (var snapshot in Firestore.instance
        .collection('categories')
        .where("email", isEqualTo: logInUser)
        .snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
      setState(() {});
    }
  }

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      //print(logInUser);
      setState(() {
        categoryStream();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text('Mai Tung Si'),
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
          showAddCategory();
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
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, SearchScreen.id);
                },
              ),
              IconButton(
                icon: Icon(Icons.assessment, color: Colors.white),
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
            .collection("categories")
            .where("email", isEqualTo: logInUser)
            .orderBy("category")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              );
            default:
              List<ReusableButton> categoryListWidget = [];
              final categoryList = snapshot.data.documents;

              for (var category in categoryList) {
                //print(category.data['category']);
                final ReusableButton categoryButton = ReusableButton(
                  text: category.data['category'],
                  onPress: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('category', category.data['category']);
                    Navigator.pushNamed(context, DetailedListScreen.id);
                  },
                );
                categoryListWidget.add(categoryButton);
              }
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: categoryListWidget,
              );
          }
        });
  }
}
