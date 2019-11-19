import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart' as prefix0;
import 'components/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';
import 'components/my_drawer.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sentiment extends StatefulWidget {
  final String link;
  Sentiment({this.link});

  @override
  _SentimentState createState() => _SentimentState();
}

class _SentimentState extends State<Sentiment> {
  final Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedUser;
  int numberOfComments = 0;
  String link;
  List<IAPItem> items = [];
  List<PurchasedItem> purchases = [];
  PurchasedItem purchasedItem;
  StreamSubscription purchaseUpdatedSubscription;
  StreamSubscription purchaseErrorSubscription;

  @override
  void initState() {
    super.initState();
    link = widget.link;
    getCurrentUser();
    asyncInitState();
  }

  @override
  void dispose() {
    super.dispose();
    endConnection();
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

  void asyncInitState() async {
    //////////////// initializing connection to store ////////////////////////
    var result = await FlutterInappPurchase.instance.initConnection;
    print('RESULT IS: $result');

    prefix0.FlutterInappPurchase.instance.consumeAllItems;

    //////////////// LISTENER FOR PURCHASE RESULTS ////////////////////////
    purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      print('purchase-updated: $productItem');

      //////////////// PURCHASE VERIFICATION ////////////////////////
      String finalized =
          await FlutterInappPurchase.instance.acknowledgePurchaseAndroid(
        productItem.purchaseToken,
        developerPayload: 'okay',
      );

      //////////////// UPDATE DATABASE WITH PURCHASE DATA ////////////////////////
      var tokenRef = _firestore.collection('users').document(loggedUser.email);
      await tokenRef.updateData(
        {
          'transactionId': productItem.transactionId,
          'transactionDate': productItem.transactionDate,
          'productId': productItem.productId,
          'purchaseToken': productItem.purchaseToken,
          'finishTransaction': finalized,
        },
      );
      print('PURCHASE FINALIZED::::::::::: $finalized');
    });

    purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
  }

  Future getProducts() async {
    List<IAPItem> items0 = await FlutterInappPurchase.instance
        .getProducts(<String>['item1_nonconsume']);
    for (var item in items0) {
      print('${item.toString()}');
      items.add(item);
    }
  }

  Future endConnection() async {
    await FlutterInappPurchase.instance.endConnection;
    purchaseUpdatedSubscription.cancel();
    purchaseUpdatedSubscription = null;
    purchaseErrorSubscription.cancel();
    purchaseErrorSubscription = null;
  }

  Future<String> getResults(String id) async {
    String vId = id;
    final regExp = RegExp(
        r"(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})?");
    var myList = regExp.allMatches(vId).toList();
    var videoId = myList[0].group(1);
    String url = 'http://faizollah.pythonanywhere.com/sentiment/$videoId';
    http.Response response = await http.get(url);
    String responseBody = response.body;
    return responseBody;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(59, 66, 84, 1.0),
        appBar: myAppBar,
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Card(
                  ///////////////////////////////////////// CARD 1 /////////////////////////////
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Color.fromRGBO(84, 93, 110, .9),
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 6.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Comments\' Statistics',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF1744),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white70,
                        indent: 30.0,
                        endIndent: 30.0,
                        thickness: 1.5,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Number of Comments: $numberOfComments',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FutureBuilder(
                        future: getResults(link),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var data = jsonDecode(snapshot.data);
                            String negative = data['negative'];
                            String positive = data['positive'];
                            double n = double.parse(negative);
                            double p = double.parse(positive);
                            Map<String, double> chartData = Map();
                            chartData.putIfAbsent("Positive", () => p);
                            chartData.putIfAbsent("Negative", () => n);
                            return Column(
                              children: <Widget>[
                                Text(
                                  'Positive sentiment: ${p.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Negative sentiment: ${n.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                PieChart(dataMap: chartData),
                              ],
                            );
                          } else {
                            return new CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Card(
                  ///////////////////////////////////////// CARD 2 /////////////////////////////
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Color.fromRGBO(84, 93, 110, .9),
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 6.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: FlatButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            width: 2.0,
                            color: Colors.red,
                          ),
                        ),
                        label: Expanded(
                          child: Text(
                            'Tap for More Analysis',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        icon: Image(
                          image: AssetImage('assets/more.png'),
                          height: 80.0,
                          width: 80.0,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),
                        onPressed: () async {
                          try {
                            getProducts().then(
                              (i) async {
                                purchasedItem = await FlutterInappPurchase
                                    .instance
                                    .requestPurchase(items[0].productId);
                              },
                            );
                          } catch (e) {
                            print('Error in purchasing: $e');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
