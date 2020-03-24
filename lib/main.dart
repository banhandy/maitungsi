import 'package:flutter/material.dart';
import 'package:maitungsi/screens/detailitem.dart';
import 'package:maitungsi/screens/categorylist.dart';
import 'package:maitungsi/screens/login.dart';
import 'package:maitungsi/screens/register.dart';
import 'package:maitungsi/screens/searchitem.dart';
import 'package:maitungsi/screens/splash.dart';
import 'package:maitungsi/screens/pricehistory.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Buy List',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(58, 66, 86, 1.0),
        ),
        primaryColor: Colors.blueGrey,
        hintColor: Colors.white,
        scaffoldBackgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        CategoryScreen.id: (context) => CategoryScreen(),
        DetailedListScreen.id: (context) => DetailedListScreen(),
        PriceHistoryScreen.id: (context) => PriceHistoryScreen(),
        SearchScreen.id: (context) => SearchScreen()
      },
    );
  }
}
