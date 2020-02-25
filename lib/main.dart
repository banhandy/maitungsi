import 'package:flutter/material.dart';
import 'package:maitungsi/screens/groupbuy.dart';
import 'package:maitungsi/screens/login.dart';
import 'package:maitungsi/screens/register.dart';
import 'package:maitungsi/screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Buy List',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        scaffoldBackgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        GroupBuy.id: (context) => GroupBuy()
      },
    );
  }
}
