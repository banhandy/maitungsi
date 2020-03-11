import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maitungsi/components/reusablebutton.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

  TextEditingController _textFieldControllername = TextEditingController();
  TextEditingController _textFieldControllerqty = TextEditingController();
  TextEditingController _textFieldControllerprice = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void showAddCategory() {
    Alert(
        context: context,
        title: "Add Item",
        content: Column(
          children: <Widget>[
            TextField(
              controller: _textFieldControllername,
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.add_shopping_cart),
                labelText: 'Item',
              ),
            ),
            TextField(
              controller: _textFieldControllerprice,
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
              controller: _textFieldControllerqty,
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
                _textFieldControllername.clear();
                _textFieldControllerprice.clear();
                _textFieldControllerqty.clear();
                Firestore.instance.collection('tungsi').document().setData({
                  'category': categoryInput,
                  'date': Timestamp.now(),
                  'email': logInUser,
                  'name': name,
                  'price': double.parse(price),
                  'quantity': double.parse(quantity)
                });
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

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      categoryInput = prefs.getString('category');
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryInput),
      ),
      body: DetailedList(logInUser, categoryInput),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        onPressed: () {
          //Navigator.pushNamed(context, InputItem.id);
          //_displayDialog(context);
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
            final itemList = snapshot.data.documents;
            for (var item in itemList) {
              final ReusableButton categoryButton = ReusableButton(
                text: item.data['name'],
                onPress: () {},
//            () async {
//              SharedPreferences prefs = await SharedPreferences.getInstance();
//              prefs.setString('category', category.data['category']);
//              Navigator.pushNamed(context, DetailedListScreen.id);
//            },
              );
              categoryListWidget.add(categoryButton);
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
