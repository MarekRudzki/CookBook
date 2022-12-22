import 'package:flutter/material.dart';

import '/src/services/firebase/firestore.dart';

class AccountProvider with ChangeNotifier {
  final Firestore _firestore = Firestore();
  String username = '';
  String email = '';
  String errorMessage = '';
  bool isCreatingAccount = false;
  bool isLoading = false;

  Future<void> setUsername() async {
    await _firestore.getUsername().then((value) {
      username = value;
    });
    notifyListeners();
  }

  void changeUsername(String value) {
    username = value;
    notifyListeners();
  }

  void addErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void switchLoginRegister() {
    isCreatingAccount = !isCreatingAccount;
    notifyListeners();
  }

  Future<void> resetErrorMessage() async {
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    errorMessage = '';
    notifyListeners();
  }
}
