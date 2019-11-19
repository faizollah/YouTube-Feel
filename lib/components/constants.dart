import 'package:flutter/material.dart';

final myAppBar = AppBar(
  title: Row(
    children: <Widget>[
      Image.asset('assets/app_icon.png'),
      SizedBox(
        width: 5.0,
      ),
      Text(
        'YouTube Feel',
        style: TextStyle(fontFamily: 'Poppins'),
      ),
    ],
  ),
  backgroundColor: Color.fromRGBO(59, 66, 84, 1.0),
  elevation: 0.0,
);

final stepperText = TextStyle(
  fontSize: 15.0,
  color: Color(0xFF00D686),
  fontWeight: FontWeight.bold,
  fontFamily: 'Poppins',
);

final aboutUs = Text(
  'We welcome you to this application that is built to complement your YouTube experience. Learning more about a video\'s comments is an ideal way to understand the video and viewers\' feedback. However, reading through hundreds or thousands of comments is not possible. This application fills this gap by providing various analysis of the comments using state-of-the-art machine learning algorithms. We hope that you enjoy this application. Please do not hesitate to contact us, should you have any questions.',
  textAlign: TextAlign.left,
  style: TextStyle(fontFamily: 'Poppins'),
);
