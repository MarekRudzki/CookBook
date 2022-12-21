import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _user = FirebaseAuth.instance;
  String? get email => _user.currentUser!.email;
  String? get uid => _user.currentUser!.uid;

  Future<String> logIn({
    required String email,
    required String password,
  }) async {
    String errorValue = '';

    if (email.isEmpty || password.isEmpty) {
      errorValue = 'Please fill in all fields';
      return errorValue;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        errorValue = 'No Internet connection';
      } else if (e.code == 'wrong-password') {
        errorValue = 'Given password is incorrect';
      } else if (e.code == 'user-not-found') {
        errorValue = 'No user found for given email';
      } else if (e.code == 'too-many-requests') {
        errorValue = 'Too many attempts, please try again later';
      } else if (e.code == 'invalid-email') {
        errorValue = 'Email adress is not valid';
      } else {
        errorValue = 'Unknown error';
      }
    }
    return errorValue;
  }

  Future<String> register({
    required String email,
    required String password,
    required String username,
    required String confirmedPassword,
  }) async {
    String errorValue = '';

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmedPassword.isEmpty) {
      errorValue = 'Please fill in all fields';
      return errorValue;
    }

    if (password != confirmedPassword) {
      errorValue = "Given passwords don't match";
      return errorValue;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        errorValue = 'No Internet connection';
      } else if (e.code == 'invalid-email') {
        errorValue = 'Email adress is not valid';
      } else if (e.code == 'weak-password') {
        errorValue = 'Given password is too weak';
      } else if (e.code == 'email-already-in-use') {
        errorValue = 'Account with given email already exist';
      } else {
        errorValue = 'Unknown error';
      }
    }
    return errorValue;
  }

  Future<String> resetPassword({
    required String passwordResetText,
  }) async {
    String errorValue = '';

    if (passwordResetText.trim().isEmpty) {
      errorValue = 'Field is empty';
      return errorValue;
    }

    try {
      await _user.sendPasswordResetEmail(
        email: passwordResetText.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        errorValue = 'Email adress is not valid';
      } else if (e.code == 'user-not-found') {
        errorValue = 'User not found';
      } else {
        errorValue = 'Unknown error';
      }
    }
    print(errorValue);
    return errorValue;
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmedNewPassword,
  }) async {
    String errorValue = '';
    final UserCredential _userCredential = await _user.currentUser!
        .reauthenticateWithCredential(EmailAuthProvider.credential(
      email: _user.currentUser!.email!,
      password: currentPassword,
    ));
    _userCredential.user;

    if (currentPassword.trim().isEmpty ||
        newPassword.trim().isEmpty ||
        confirmedNewPassword.trim().isEmpty) {
      errorValue = 'Please fill in all fields';
      return errorValue;
    }

    try {
      await _user.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorValue = 'Password is weak';
      } else {
        errorValue = 'Unknown error';
      }
    }
    return errorValue;
  }

  Future<String> deleteUser() async {
    String errorValue = '';
    try {
      await _user.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      errorValue = e.code;
    }
    return errorValue;
  }

  Future<String> signOut() async {
    String errorValue = '';
    try {
      await _user.signOut();
    } on FirebaseAuthException catch (e) {
      errorValue = e.code;
    }
    return errorValue;
  }
}
