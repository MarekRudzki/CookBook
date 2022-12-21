import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool isCreatingAccount = false;
  bool isLoading = false;
  String errorMessage = '';

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void switchLoginRegister() {
    isCreatingAccount = !isCreatingAccount;
    notifyListeners();
  }

  void addErrorMessage(String message) {
    errorMessage = message;
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
