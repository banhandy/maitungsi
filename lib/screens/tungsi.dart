import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:maitungsi/components/itemcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tungsi extends StatefulWidget {
  static const id = 'tungsi_screen';

  @override
  _TungsiState createState() => _TungsiState();
}

class _TungsiState extends State<Tungsi> {
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
        title: Text(item),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: ItemList(logInUser, categoryInput, item)),
            Container(
              height: 70.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(64, 75, 96, 0.9),
                  border: Border(
                      top: BorderSide(
                          color: Colors.grey,
                          width: 3.0))), //padding: EdgeInsets.all(15.0),
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
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
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
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 22.0,
                      ),
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

class ItemList extends StatefulWidget {
  final String logInUser;
  final String category;
  final String item;
  ItemList(this.logInUser, this.category, this.item);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("tungsi")
          .where("email", isEqualTo: widget.logInUser)
          .where("category", isEqualTo: widget.category)
          .where("name", isEqualTo: widget.item)
          .orderBy("date")
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          await Firestore.instance
                              .collection("tungsi")
                              .document(item.documentID)
                              .delete();
                          Navigator.pop(context);
                          setState(() {});
                        },
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      ),
                      DialogButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
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
