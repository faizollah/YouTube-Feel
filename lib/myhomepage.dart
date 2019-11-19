import 'package:flutter/material.dart';
import 'package:youtube_feel_flutter/components/constants.dart';
import 'package:youtube_feel_flutter/components/signInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_feel_flutter/sentiment.dart';
import 'guide.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool userLoggedOut;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    final FirebaseUser user = await auth.currentUser();
    if (user == null) {
      setState(() {
        userLoggedOut = true;
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Guide(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(59, 66, 84, 1.0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/pic1.png',
                width: 300.0,
              ),
              SizedBox(
                height: 60.0,
              ),
              userLoggedOut == true ? SignInButton() : Text(''),
            ],
          ),
        ),
      ),
    );
  }
}
