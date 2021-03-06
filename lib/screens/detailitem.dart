import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maitungsi/screens/pricehistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maitungsi/components/cardwithtittle.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:maitungsi/constants.dart';

class DetailedListScreen extends StatefulWidget {
  static const id = 'detailed_screen';
  @override
  _DetailedListScreenState createState() => _DetailedListScreenState();
}

class _DetailedListScreenState extends State<DetailedListScreen> {
  String logInUser;
  String categoryInput = '';

  String name;
  String quantity;
  String price;

  TextEditingController _textFieldControllerName = TextEditingController();
  TextEditingController _textFieldControllerQty = TextEditingController();
  TextEditingController _textFieldControllerPrice = TextEditingController();

  void showAddCategory() {
    Alert(
        context: context,
        title: "Add Item",
        content: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              controller: _textFieldControllerName,
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.add_shopping_cart),
                labelText: 'Item',
              ),
            ),
            TextField(
              controller: _textFieldControllerPrice,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                price = value;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.attach_money),
                labelText: 'Price',
              ),
            ),
            TextField(
              controller: _textFieldControllerQty,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                quantity = value;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.content_paste),
                labelText: 'Quantity',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (name != null &&
                  name != '' &&
                  quantity != null &&
                  quantity != '' &&
                  price != null &&
                  price != '') {
                _textFieldControllerName.clear();
                _textFieldControllerPrice.clear();
                _textFieldControllerQty.clear();
                Firestore.instance.collection('tungsi').document().setData({
                  'category': categoryInput,
                  'date': Timestamp.now(),
                  'email': logInUser,
                  'name': name,
                  'price': double.parse(price),
                  'quantity': double.parse(quantity)
                });
                setState(() {
                  name = '';
                  price = '';
                  quantity = '';
                  Navigator.pop(context);
                });
              }
            },
            child: Text(
              "Submit",
              style: kMainTextStyle,
            ),
            color: kPrimaryColor,
          )
        ]).show();
  }

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      categoryInput = prefs.getString('category');
      setState(() {
        categoryStream();
      });
    } catch (e) {
      print(e);
    }
  }

  void categoryStream() async {
    await for (var snapshot in Firestore.instance
        .collection('tungsi')
        .where("email", isEqualTo: logInUser)
        .where("category", isEqualTo: categoryInput)
        .snapshots()) {
      for (var message in snapshot.documents) {
        //print(message.data['name']);
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textFieldControllerName.dispose();
    _textFieldControllerPrice.dispose();
    _textFieldControllerQty.dispose();
    super.dispose();
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
        title: Text(categoryInput),
      ),
      body: DetailedList(logInUser, categoryInput),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: kSecondaryColor,
        ),
        backgroundColor: kMainColor,
        onPressed: () {
          showAddCategory();
        },
      ),
    );
  }
}

class DetailedList extends StatelessWidget {
  final String logInUser;
  final String category;

  DetailedList(this.logInUser, this.category);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("tungsi")
          .where("email", isEqualTo: logInUser)
          .where("category", isEqualTo: category)
          .orderBy("name")
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
            String flagName = '';
            final itemList = snapshot.data.documents;
            for (var item in itemList) {
              if (flagName != item.data['name']) {
                flagName = item.data['name'];
                final ReusableButton categoryButton = ReusableButton(
                  text: item.data['name'],
                  onPress: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('item', item.data['name']);
                    Navigator.pushNamed(context, PriceHistoryScreen.id);
                  },
                );

                categoryListWidget.add(categoryButton);
              }
            }
            return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: categoryListWidget,
            );
        }
      },
    );
  }
}
