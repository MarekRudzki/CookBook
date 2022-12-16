import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _user = FirebaseAuth.instance;
  String? get email => _user.currentUser!.email;

  Future<String> logIn(
      {required String email, required String password}) async {
    String errorValue = '';
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        return errorValue = 'No Internet connection';
      } else if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return errorValue = 'Please enter correct password and email';
      } else if (e.code == 'too-many-requests') {
        return errorValue = 'Too many attempts, please try again later';
      } else if (e.code == 'invalid-email') {
        return errorValue = 'Email adress is not valid';
      } else {
        return errorValue = 'Unknown error';
      }
    }
    return errorValue;
  }

  Future<String> deleteUser() async {
    String errorValue = '';
    try {
      await _user.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      errorValue = e.toString();
    }
    return errorValue;
  }

  Future<String> signOut() async {
    String errorValue = '';
    try {
      await _user.signOut();
    } catch (e) {
      errorValue = e.toString();
    }
    return errorValue;
  }
}
