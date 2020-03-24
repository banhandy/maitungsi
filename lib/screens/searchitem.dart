import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitungsi/components/searchitemcard.dart';
import 'package:maitungsi/screens/pricehistory.dart';

class SearchScreen extends StatefulWidget {
  static String id = 'search screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String logInUser;
  List<SearchItemTungsi> searchList = [];
  Widget appBarTitle = Text('Search');
  String filter = '';
  String flagName = '';
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
    await for (var snapshot in Firestore.instance
        .collection('tungsi')
        .where("email", isEqualTo: logInUser)
        .orderBy("name")
        .snapshots()) {
      for (var message in snapshot.documents) {
        if (flagName != message.data['name']) {
          flagName = message.data['name'];
          SearchItemTungsi item = SearchItemTungsi(
              category: message.data['category'], name: message.data['name']);
          searchList.add(item);
          flagName = message.data['name'];
        }
        //print(message.data);
      }
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
          print(filter);
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
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                this.appBarTitle = TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _searchQuery,
                  decoration: InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)),
                );
              });
            },
          )
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
                    print('click');
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
                        print('click');
                      },
                    )
                  : Container();
        },
      ),
    );
  }
}

class SearchItemTungsi {
  final String name;
  final String category;

  SearchItemTungsi({this.category, this.name});
}
