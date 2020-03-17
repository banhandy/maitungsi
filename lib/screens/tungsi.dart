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
      appBar: AppBar(
        title: Text(item),
      ),
      body: TungsiList(logInUser, categoryInput, item),
    );
  }
}

class TungsiList extends StatelessWidget {
  final String logInUser;
  final String category;
  final String item;

  TungsiList(this.logInUser, this.category, this.item);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("tungsi")
          .where("email", isEqualTo: logInUser)
          .where("category", isEqualTo: category)
          .where("name", isEqualTo: item)
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
                onPress: () {},
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
