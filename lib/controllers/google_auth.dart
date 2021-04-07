import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notist/screens/home_screen.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference _users = FirebaseFirestore.instance.collection('users');

Future<bool?> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      final User user = authResult.user!;

      var userData = {
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'provider': 'google',
      };

      _users.doc(user.uid).get().then((doc) {
        if (doc.exists) {
          //update old data
          doc.reference.update(userData);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => HomeScreen(),
            ),
          );
        } else {
          //set new data
          _users.doc(user.uid).set(userData);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => HomeScreen(),
            ),
          );
        }
      });
    }
  } catch (PlatformException) {
    print('sign in not successful');
  }
}
