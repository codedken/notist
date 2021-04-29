import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<void> signUp(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final authUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Map<String, dynamic> _user = {
        'name': displayName,
        'email': email,
        'provider': 'EmailandPassword',
      };

      db.collection('users').doc(authUser.user!.uid).get().then((doc) {
        if (doc.exists) {
          doc.reference.update(_user);
        } else {
          db.collection('users').doc(authUser.user!.uid).set(_user);
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        throw 'Email already exists';
      }
    } catch (e) {
      throw 'something went wrong';
    }
  }

  Future<void> login(String email, String password) async {
    print('things');
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Account does not exist';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password';
      }
    } catch (e) {
      throw 'Something went wrong';
    }
  }
}
