import 'package:flutter/material.dart';
import 'package:maitungsi/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitungsi/components/searchitemcard.dart';
import 'package:maitungsi/screens/pricehistory.dart';
import 'package:maitungsi/model.dart';

class SearchScreen extends StatefulWidget {
  static String id = 'search screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String logInUser;
  List<ItemList> searchList = [];
  Widget appBarTitle = Text('Search');
  String filter = '';
  String flagName = '';
  String flagCategory = '';
  bool flagShow = true;
  final TextEditingController _searchQuery = new TextEditingController();

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      setState(() {
        categoryStream();
      });
    } catch (e) {
      print(e);
    }
  }

  void categoryStream() async {
    var nameCategoryMap = Map();
    await for (var snapshot in Firestore.instance
        .collection('tungsi')
        .where("email", isEqualTo: logInUser)
        .orderBy("name")
        .snapshots()) {
      for (var message in snapshot.documents) {
        nameCategoryMap[message.data['name']] = message.data['category'];
      }
      nameCategoryMap.forEach((k, v) {
        ItemList item = ItemList(category: v, name: k);
        searchList.add(item);
      });

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          filter = '';
        });
      } else {
        setState(() {
          filter = _searchQuery.text;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: <Widget>[
          Visibility(
            visible: flagShow,
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: kSecondaryColor,
              ),
              onPressed: () {
                flagShow = false;
                setState(() {
                  this.appBarTitle = TextField(
                    autofocus: true,
                    style: kMainTextStyle,
                    controller: _searchQuery,
                    decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: kMainTextStyle.copyWith(color: Colors.grey)),
                  );
                });
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          return filter == null || filter == ""
              ? SearchItemCard(
                  text: searchList[index].name,
                  category: searchList[index].category,
                  onPress: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('item', searchList[index].name);
                    prefs.setString('category', searchList[index].category);
                    Navigator.pushReplacementNamed(
                        context, PriceHistoryScreen.id);
                  },
                )
              : searchList[index]
                      .name
                      .toLowerCase()
                      .contains(filter.toLowerCase())
                  ? SearchItemCard(
                      text: searchList[index].name,
                      category: searchList[index].category,
                      onPress: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('item', searchList[index].name);
                        prefs.setString('category', searchList[index].category);
                        Navigator.pushReplacementNamed(
                            context, PriceHistoryScreen.id);
                        //print('click');
                      },
                    )
                  : Container();
        },
      ),
    );
  }
}
