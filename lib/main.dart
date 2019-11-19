import 'package:flutter/material.dart';
import 'myhomepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YouTube Feel',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
        backgroundColor: Color.fromRGBO(59, 66, 84, 1.0),
      ),
      home: MyHomePage(),
    );
  }
}
