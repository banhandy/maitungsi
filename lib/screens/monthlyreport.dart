import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maitungsi/components/monthlycard.dart';
import 'package:maitungsi/screens/reportdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maitungsi/model.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyReportScreen extends StatefulWidget {
  static String id = 'Monthly Report Screen';
  @override
  _MonthlyReportScreenState createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  String logInUser;
  List<MonthlyList> monthList = [];
  double totalMonth = 0.0;
  int flagMonth = 0;
  int flagYear = 0;

  getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logInUser = prefs.getString('email');
      setState(() {
        getStream();
      });
    } catch (e) {
      print(e);
    }
  }

  getStream() async {
    int index;
    var monthYearMap = Map();
    var monthYearValueMap = Map();
    await for (var snapshot in Firestore.instance
        .collection('tungsi')
        .where("email", isEqualTo: logInUser)
        .orderBy("date", descending: true)
        .snapshots()) {
      for (var message in snapshot.documents) {
        Timestamp tempDate = message.data['date'];
        double price = message.data['price'];
        double qty = message.data['quantity'];
        flagMonth = tempDate.toDate().month;
        flagYear = tempDate.toDate().year;
        monthYearMap[flagMonth] = flagYear;
        monthYearValueMap[flagYear + flagMonth] == null
            ? monthYearValueMap[flagYear + flagMonth] = price * qty
            : monthYearValueMap[flagYear + flagMonth] += price * qty;
        print(flagMonth.toString() + ' ' + flagYear.toString());
      }
      monthYearMap.forEach((k, v) {
        monthYearValueMap.forEach((myk, myv) {
          if ((k + v) == myk) {
            MonthlyList item = MonthlyList(month: k, year: v, value: myv);
            monthList.add(item);
          }
        });
      });
      setState(() {});
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
        title: Text('Reports'),
      ),
      body: ListView.builder(
          itemCount: monthList.length,
          itemBuilder: (context, index) {
            return MonthlyCard(
              month: monthList[index].month,
              year: monthList[index].year,
              value: monthList[index].value,
              onPress: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt('month', monthList[index].month);
                prefs.setInt('year', monthList[index].year);
                Navigator.pushNamed(context, ReportDetailScreen.id);
              },
            );
          }),
    );
  }
}
