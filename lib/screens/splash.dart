import 'package:flutter/material.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'groupbuy.dart';

class Splash extends StatefulWidget {
  static const id = 'splash_screen';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child:
              CircleAvatar(radius: 50.0, child: Image.asset('images/logo.png')),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLoginUser();
  }

  getLoginUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('email') != null) {
        //print(prefs.getString('email'));
        Future.delayed(
          Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, GroupBuy.id),
        );
      } else {
        Future.delayed(
          Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(context, LoginScreen.id),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
