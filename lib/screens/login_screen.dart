import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:Euro_prediction/components/rounded_button.dart';
import 'package:Euro_prediction/constants.dart';
import 'package:Euro_prediction/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          //  child: ModalProgressHUD(
          //    inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/UEFA_Euro_2020_Logo.webp'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    title: 'Log In',
                    colour: Colors.lightBlueAccent,
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, MainScreen.id);
                        }
                        setState(() {
                          //showSpinner = false;
                        });
                      } catch (e) {
                        print('error caught');
                        _ackAlert(context);
                        //print(e);
                      }
                    }),
              ],
            ),
          ),
          //),
        ),
      ),
    );
  }

  Future _ackAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: const Text('Please check the emailId and password'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
