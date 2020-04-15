import 'package:flutter/material.dart';
import 'package:maitungsi/screens/detailitem.dart';
import 'package:maitungsi/screens/categorylist.dart';
import 'package:maitungsi/screens/login.dart';
import 'package:maitungsi/screens/monthlyreport.dart';
import 'package:maitungsi/screens/register.dart';
import 'package:maitungsi/screens/reportdetail.dart';
import 'package:maitungsi/screens/searchitem.dart';
import 'package:maitungsi/screens/splash.dart';
import 'package:maitungsi/screens/pricehistory.dart';
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maitungsi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: kMainColor,
        ),
        primaryColor: Colors.blueGrey,
        hintColor: Colors.white,
        scaffoldBackgroundColor: kMainColor,
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        CategoryScreen.id: (context) => CategoryScreen(),
        DetailedListScreen.id: (context) => DetailedListScreen(),
        PriceHistoryScreen.id: (context) => PriceHistoryScreen(),
        SearchScreen.id: (context) => SearchScreen(),
        MonthlyReportScreen.id: (context) => MonthlyReportScreen(),
        ReportDetailScreen.id: (context) => ReportDetailScreen()
      },
    );
  }
}
