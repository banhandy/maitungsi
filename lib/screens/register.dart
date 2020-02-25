import 'package:flutter/material.dart';
import 'package:maitungsi/components/roundbutton.dart';
import 'package:maitungsi/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maitungsi/screens/groupbuy.dart';
import 'package:email_validator/email_validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool isValid = true;
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
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    speed: Duration(seconds: 1),
                    text: ['SIGN UP'],
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                  isValid = EmailValidator.validate(email);
                },
                decoration: kInputDecoration.copyWith(labelText: 'Enter Email'),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
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
                buttonColor: Colors.blueAccent,
                buttonText: 'Sign Up',
                onPressed: () async {
                  if ((isValid) && ((email != null) && (password != null))) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser = _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', email);
                        Navigator.pushReplacementNamed(context, GroupBuy.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {}
                  } else {
                    setState(() {});
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Visibility(
                    visible: !isValid,
                    child: Center(
                        child: Text(
                      'Email Error',
                      style: TextStyle(color: Colors.red),
                    ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
