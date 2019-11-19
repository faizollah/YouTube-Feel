import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final Firestore _firestore = Firestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  String fcmToken = await _fcm.getToken();
  if (fcmToken != null) {
    var tokenRef = _firestore.collection('users').document(user.email);
    await tokenRef.updateData(
      {
        'fcmToken': fcmToken,
        'lastLogin': Timestamp.now(),
        'platform': Platform.operatingSystem,
      },
    );
  }

  return 'signInWithGoogle succeeded: $user';
}
