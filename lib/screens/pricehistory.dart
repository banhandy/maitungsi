import 'package:flutter/material.dart';
import 'package:maitungsi/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:maitungsi/components/historycard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PriceHistoryScreen extends StatefulWidget {
  static const id = 'tungsi_screen';

  @override
  _PriceHistoryScreenState createState() => _PriceHistoryScreenState();
}

class _PriceHistoryScreenState extends State<PriceHistoryScreen> {
  String logInUser;
  String categoryInput = '';
  TextEditingController _textFieldControllerQty = TextEditingController();
  TextEditingController _textFieldControllerPrice = TextEditingController();
  String item = '';
  String quantity;
  String price;

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      categoryInput = prefs.getString('category');
      item = prefs.getString('item');
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textFieldControllerQty.dispose();
    _textFieldControllerPrice.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(item + ' - Price History'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: PriceHistoryList(logInUser, categoryInput, item)),
            Container(
              height: 70.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: TextField(
                        controller: _textFieldControllerPrice,
                        onChanged: (value) {
                          price = value;
                        },
                        style: TextStyle(color: Colors.white),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration:
                            kInputDecoration.copyWith(labelText: 'Price'),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: TextField(
                          controller: _textFieldControllerQty,
                          onChanged: (value) {
                            quantity = value;
                          },
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration:
                              kInputDecoration.copyWith(labelText: 'Quantity'),
                        ),
                      )),
                  FlatButton(
                    onPressed: () {
                      if (price != null &&
                          price != '' &&
                          quantity != null &&
                          quantity != '') {
                        _textFieldControllerPrice.clear();
                        _textFieldControllerQty.clear();
                        Firestore.instance
                            .collection('tungsi')
                            .document()
                            .setData({
                          'category': categoryInput,
                          'date': Timestamp.now(),
                          'email': logInUser,
                          'name': item,
                          'price': double.parse(price),
                          'quantity': double.parse(quantity)
                        });
                        setState(() {
                          price = '';
                          quantity = '';
                        });
                      }
                    },
                    child: Text(
                      'Add',
                      style: kMainTextStyle.copyWith(color: kSecondaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceHistoryList extends StatefulWidget {
  final String logInUser;
  final String category;
  final String item;
  PriceHistoryList(this.logInUser, this.category, this.item);
  @override
  _PriceHistoryListState createState() => _PriceHistoryListState();
}

class _PriceHistoryListState extends State<PriceHistoryList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("tungsi")
          .where("email", isEqualTo: widget.logInUser)
          .where("category", isEqualTo: widget.category)
          .where("name", isEqualTo: widget.item)
          .orderBy("date", descending: true)
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
            List<ItemCard> itemListWidget = [];
            final itemList = snapshot.data.documents;
            for (var item in itemList) {
              final ItemCard itemButton = ItemCard(
                date: item.data['date'],
                quantity: item.data['quantity'],
                value: item.data['price'],
                onPress: () {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Delete Data",
                    desc: "Do you want to delete this transaction?",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Yes",
                          style: kMainTextStyle,
                        ),
                        onPressed: () async {
                          await Firestore.instance
                              .collection("tungsi")
                              .document(item.documentID)
                              .delete();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        color: kPrimaryColor,
                      ),
                      DialogButton(
                        child: Text(
                          "Cancel",
                          style: kMainTextStyle,
                        ),
                        color: kSecondaryColor,
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ).show();
                },
              );

              itemListWidget.add(itemButton);
            }
            return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: itemListWidget,
            );
        }
      },
    );
  }
}
