import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maitungsi/constants.dart';
import 'package:maitungsi/components/roundbutton.dart';
import 'package:maitungsi/screens/categorylist.dart';
import 'package:maitungsi/screens/register.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: kMainTextStyle,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputDecoration.copyWith(labelText: 'Enter Email'),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                obscureText: true,
                style: kMainTextStyle,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration:
                    kInputDecoration.copyWith(labelText: 'Enter Password'),
              ),
              SizedBox(
                height: 10.0,
              ),
              RoundButton(
                buttonColor: kPrimaryColor,
                buttonText: 'Login',
                onPressed: () async {
                  if (email != null && password != null) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        loggedInUser = user.user;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', loggedInUser.email);
                        Navigator.pushReplacementNamed(
                            context, CategoryScreen.id);
                      }
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              RoundButton(
                buttonColor: kSecondaryColor,
                buttonText: 'Register',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, RegisterScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
