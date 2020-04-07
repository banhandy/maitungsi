import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maitungsi/components/calendar.dart';
import 'package:maitungsi/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitungsi/components/reportcard.dart';
import 'package:maitungsi/model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:maitungsi/components/chart.dart';

class ReportDetailScreen extends StatefulWidget {
  static String id = 'Report Detail Screen';
  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  String logInUser;
  int month;
  int year;
  double totalCategory = 0.0;
  double totalDetail = 0.0;
  List<CategoryList> categoryList = [];
  // CalendarController _calendarController;
  Map<DateTime, List> _events = Map();
  //AnimationController _animationController;
  // List<DailyDetailList> _selectedEvents;

  String generateMonth(int month) {
    String monthName = '';
    switch (month) {
      case (1):
        {
          monthName = 'JAN';
        }
        break;
      case (2):
        {
          monthName = 'FEB';
        }
        break;
      case (3):
        {
          monthName = 'MAR';
        }
        break;
      case (4):
        {
          monthName = 'APR';
        }
        break;
      case (5):
        {
          monthName = 'MAY';
        }
        break;
      case (6):
        {
          monthName = 'JUN';
        }
        break;
      case (7):
        {
          monthName = 'JUL';
        }
        break;
      case (8):
        {
          monthName = 'AUG';
        }
        break;
      case (9):
        {
          monthName = 'SEP';
        }
        break;
      case (10):
        {
          monthName = 'OCT';
        }
        break;
      case (11):
        {
          monthName = 'NOV';
        }
        break;
      case (12):
        {
          monthName = 'DEC';
        }
        break;
    }
    return monthName;
  }

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      month = prefs.getInt('month');
      year = prefs.getInt('year');
      setState(() {
        getStream();
      });
    } catch (e) {
      print(e);
    }
  }

  getStream() async {
    var categoryMap = Map();
    var itemMap = Map();
    var dateMap = Map();
    var dateItemMap = Map();
    var categoryItemMap = Map();

    List<Map> dateItemMapList = [];
    int index;
    int indexDetail;
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate;
    if (month == 12) {
      endDate = DateTime(year + 1, 1, 1);
    } else {
      endDate = DateTime(year, month + 1, 1);
    }

    await for (var snapshot in Firestore.instance
        .collection('tungsi')
        .where("email", isEqualTo: logInUser)
        .where("date", isGreaterThanOrEqualTo: startDate)
        .where("date", isLessThan: endDate)
        .orderBy("date")
        .orderBy("category")
        .snapshots()) {
      for (var message in snapshot.documents) {
        String category = message.data['category'];
        double price = message.data['price'];
        double qty = message.data['quantity'];
        String name = message.data['name'];
        Timestamp date = message.data['date'];
        DateTime eventDate = DateTime(
            date.toDate().year, date.toDate().month, date.toDate().day);
        dateItemMap[eventDate.toString() + name] == null
            ? dateItemMap[eventDate.toString() + name] = price * qty
            : dateItemMap[eventDate.toString() + name] += price * qty;
        dateMap[eventDate] == null
            ? dateMap[eventDate] = price * qty
            : dateMap[eventDate] += price * qty;
        categoryMap[category] == null
            ? categoryMap[category] = price * qty
            : categoryMap[category] += price * qty;
        itemMap[category + name] == null
            ? itemMap[category + name] = price * qty
            : itemMap[category + name] += price * qty;

        categoryItemMap[name] = category;
        dateItemMapList.add({
          eventDate: [name, category]
        });
      }
      categoryMap.forEach((ck, cv) {
        List<DetailList> detailList = [];
        categoryItemMap.forEach((cik, civ) {
          if (civ == ck) {
            itemMap.forEach((ik, iv) {
              if (civ + cik == ik) {
                DetailList detailItem = DetailList(itemName: cik, value: iv);
                detailList.add(detailItem);
              }
            });
          }
        });

        CategoryList item =
            CategoryList(category: ck, value: cv, detail: detailList);
        categoryList.add(item);
      });

      dateMap.forEach((dk, dv) {
        List<DailyDetailList> eventList = [];
        dateItemMapList.forEach((element) {
          if (element.keys.first == dk) {
            dateItemMap.forEach((dik, div) {
              if (element.keys.first.toString() + element.values.first[0] ==
                  dik) {
                DailyDetailList itemDailyList = DailyDetailList(
                    category: element.values.first[1],
                    itemName: element.values.first[0],
                    value: div);
                eventList.add(itemDailyList);
              }
            });
          }
        });
        _events[dk] = eventList;
      });
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(generateMonth(month) + ' ' + year.toString()),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.pie_chart),
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: PieChart(categoryList: categoryList),
                ),
                Text(
                  'Details',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Divider(
                  color: Colors.white,
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        return ReportCard(
                          value: categoryList[index].value,
                          category: categoryList[index].category,
                          detail: categoryList[index].detail,
                        );
                      }),
                ),
              ],
            ),
            CalendarWithList(
              events: _events,
            ),
          ],
        ),
      ),
    );
  }
}
