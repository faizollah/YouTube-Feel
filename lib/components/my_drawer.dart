import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_feel_flutter/components/constants.dart';

class MyDrawer extends StatelessWidget {
  final String email;

  MyDrawer({this.email});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              email,
              style: TextStyle(color: Colors.black),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/drawer_img.png'),
                fit: BoxFit.contain,
              ),
            ),
            padding: EdgeInsets.only(
              left: 5.0,
              top: 130.0,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Feedback'),
            onTap: () async {
              const link =
                  'mailto:testmailforandroid@gmail.com?subject=Feedback';
              await launch(link);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text('Rate this app'),
            onTap: () async {
              const url =
                  'https://play.google.com/store/apps/details?id=com.youtube.sentiment';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About us'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'YouTube Feel',
                applicationIcon: Image.asset('assets/app_icon.png'),
                children: <Widget>[
                  aboutUs,
                ],
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
