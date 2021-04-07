import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> signUp(String email, String password) async {
    try {
      UserCredential authUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(authUser.user!.email);
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final UserCredential authUser = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(authUser.user!.email);
    } catch (e) {
      print(e);
    }
  }
}
