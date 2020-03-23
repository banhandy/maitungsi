import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitungsi/components/searchitemcard.dart';

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
    //TODO : refined disticnt
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
                  onPress: () {},
                )
              : searchList[index]
                      .name
                      .toLowerCase()
                      .contains(filter.toLowerCase())
                  ? SearchItemCard(
                      text: searchList[index].name,
                      category: searchList[index].category,
                      onPress: () {},
                    )
                  : Container();
        },
      ),
    );
  }
}

class SearchItemList extends StatefulWidget {
  final String logInUser;

  SearchItemList({this.logInUser});

  @override
  _SearchItemListState createState() => _SearchItemListState();
}

class _SearchItemListState extends State<SearchItemList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("tungsi")
            .where("email", isEqualTo: widget.logInUser)
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
              List<SearchItemCard> searchList = [];
              final itemList = snapshot.data.documents;
              for (var item in itemList) {
                final SearchItemCard itemCard = SearchItemCard(
                  text: item.data['name'],
                  category: item.data['category'],
                  onPress: () {},
                );
                searchList.add(itemCard);
              }
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: searchList,
              );
          }
        });
  }
}

class SearchItemTungsi {
  final String name;
  final String category;

  SearchItemTungsi({this.category, this.name});
}
