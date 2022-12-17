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
        errorValue = "Given password is incorrect";
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
    return errorValue;
  }

  // try {
  //   loadingSpinner(context);
  //   await FirebaseAuth.instance.sendPasswordResetEmail(
  //     email: _passwordResetController.text.trim(),
  //   );
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'invalid-email') {
  //     errorMsg = 'Email adress is not valid';
  //   } else if (e.code == 'user-not-found') {
  //     errorMsg = 'User not found';
  //   } else {
  //     errorMsg = 'Unknown error';
  //   }
  //   return;
  // } finally {
  //   loadingSpinner(context);
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   if (errorMsg != '') {
  //     loginCubit.addErrorMessage(errorMsg);
  //     await Future.delayed(
  //       const Duration(seconds: 3),
  //     );
  //     loginCubit.addErrorMessage('');
  //   }
  // }

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
