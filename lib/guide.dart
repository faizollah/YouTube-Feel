import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_feel_flutter/components/constants.dart';
import 'package:youtube_feel_flutter/sentiment.dart';
import 'components/rounded_button.dart';
import 'components/my_drawer.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser loggedUser;

class Guide extends StatefulWidget {
  @override
  _GuideState createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user == null) {
        Navigator.pop(context);
      } else {
        print(user.email);
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(59, 66, 84, 1.0),
        appBar: myAppBar,
        drawer: MyDrawer(
          email: loggedUser == null ? '' : loggedUser.email,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  10.0,
                  20.0,
                  10.0,
                  10.0,
                ),
                child: Text(
                  "How to use YouTube Feel:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Stepper(
                currentStep: this.currentStep,
                steps: [
                  Step(
                    title: Text(
                      "Step 1",
                      style: stepperText,
                    ),
                    content: Text(
                        "Open the YouTube app and play your selected video"),
                    isActive: true,
                  ),
                  Step(
                    title: Text(
                      "Step 2",
                      style: stepperText,
                    ),
                    content: Text("Click on share button and select copy link"),
                    state: StepState.indexed,
                    isActive: true,
                  ),
                  Step(
                    title: Text(
                      "Step 3",
                      style: stepperText,
                    ),
                    content: Column(
                      children: <Widget>[
                        Text("Open this app and paste the link here"),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                    state: StepState.indexed,
                    isActive: true,
                  ),
                ],
                type: StepperType.vertical,
                onStepTapped: (step) {
                  setState(() {
                    currentStep = step;
                  });
                  print("onStepTapped : " + step.toString());
                },
                controlsBuilder: (
                  BuildContext context, {
                  VoidCallback onStepContinue,
                  VoidCallback onStepCancel,
                }) =>
                    Container(),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        15.0,
                        15.0,
                        15.0,
                        5.0,
                      ),
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0), //change height
                          hintText: 'Paste the link here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      child: Text(
                        'Start Analyzing',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: Colors.lightBlue,
                      splashColor: Colors.grey,
                      elevation: 10.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Sentiment(
                              link: myController.text,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
//              RoundedButton(
//                title: 'Sign Me Out',
//                colour: Color(0xFFFF1744),
//                onPressed: () {
//                  signOut();
//                },
//              ),
            ],
          ),
        ),
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
}
