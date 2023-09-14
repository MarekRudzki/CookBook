import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthFirebaseRemoteDataSource {
  final FirebaseAuth _user = FirebaseAuth.instance;

  String getUid() {
    return _user.currentUser!.uid;
  }

  String? getEmail() {
    return _user.currentUser!.email;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw Exception('No Internet connection');
      } else if (e.code == 'wrong-password') {
        throw Exception('Given password is incorrect');
      } else if (e.code == 'user-not-found') {
        throw Exception('No user found for given email');
      } else if (e.code == 'too-many-requests') {
        throw Exception('Too many attempts, please try again later');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email adress is not valid');
      } else {
        throw Exception('Unknown error');
      }
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String confirmedPassword,
  }) async {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmedPassword.isEmpty) {
      throw Exception('Please fill in all fields');
    }

    if (password != confirmedPassword) {
      throw Exception("Given passwords don't match");
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw Exception('No Internet connection');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email adress is not valid');
      } else if (e.code == 'weak-password') {
        throw Exception('Given password is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Account with given email already exist');
      } else {
        throw Exception('Unknown error');
      }
    }
  }

  Future<bool> resetPassword({
    required String passwordResetText,
  }) async {
    bool isReset = true;
    try {
      await _user.sendPasswordResetEmail(
        email: passwordResetText.trim(),
      );
    } on FirebaseAuthException catch (e) {
      isReset = false;
      if (e.code == 'invalid-email') {
        throw Exception('Email adress is not valid');
      } else if (e.code == 'user-not-found') {
        throw Exception('User not found');
      } else {
        throw Exception('Unknown error');
      }
    }
    return isReset;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmedNewPassword,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: getEmail()!,
        password: currentPassword,
      );
      await _user.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Current password not correct');
      } else {
        throw Exception('Unknown error');
      }
    }

    try {
      await _user.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password is weak');
      } else {
        throw Exception('Unknown error');
      }
    }
  }

  Future<void> validateUserPassword({required String password}) async {
    if (password.trim().isEmpty) {
      throw Exception('Please provide your password');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: getEmail()!,
        password: password,
      );
      await _user.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Password not correct');
      } else {
        throw Exception('Unknown error');
      }
    }
  }

  Future<void> deleteUser() async {
    try {
      await _user.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _user.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
