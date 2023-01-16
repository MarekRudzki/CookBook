import 'package:cookbook/src/features/common_widgets/error_handling.dart';
import 'package:cookbook/src/services/hive_services.dart';
import 'package:flutter/material.dart';

import '../../services/firebase/auth.dart';
import '/src/services/firebase/firestore.dart';

class AccountProvider with ChangeNotifier {
  final Firestore _firestore = Firestore();
  final ErrorHandling _errorHandling = ErrorHandling();
  final HiveServices _hiveServices = HiveServices();
  final Auth _auth = Auth();

  String username = '';
  String email = '';
  String errorMessage = '';
  bool isCreatingAccount = false;
  bool isLoading = false;
  bool deletePrivateRecipes = true;
  bool deleteAllRecipes = false;
  bool userHasRecipes = true;

  //user

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

  //user Auth

  Future<void> logIn({
    required BuildContext context,
    required String email,
    required String password,
    required TextEditingController emailController,
    required void Function() onSuccess,
  }) async {
    _errorHandling.toggleLoadingSpinner(context);

    await _auth
        .logIn(
      email: email,
      password: password,
    )
        .then(
      (errorText) {
        _errorHandling.toggleLoadingSpinner(context);
        FocusManager.instance.primaryFocus?.unfocus();
        if (errorText.isNotEmpty) {
          _errorHandling.showInfoSnackbar(context, errorText);
        } else {
          onSuccess();
          _hiveServices.setUserEmail(emailController.text);
        }
      },
    );
  }

  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String confirmedPassword,
    required TextEditingController emailController,
    required void Function() onSuccess,
  }) async {
    _errorHandling.toggleLoadingSpinner(context);

    await _auth
        .register(
      email: email,
      password: password,
      username: username,
      confirmedPassword: confirmedPassword,
    )
        .then(
      (errorText) {
        _errorHandling.toggleLoadingSpinner(context);
        FocusManager.instance.primaryFocus?.unfocus();
        if (errorText.isNotEmpty) {
          _errorHandling.showInfoSnackbar(context, errorText);
        } else {
          _firestore.addUser(username).then(
                (errorText) => {
                  if (errorText.isNotEmpty)
                    {
                      _errorHandling.showInfoSnackbar(context, errorText),
                    }
                  else
                    {
                      onSuccess(),
                      _hiveServices.setUserEmail(emailController.text),
                      _hiveServices.setUsername(username: username),
                    }
                },
              );
        }
      },
    );
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String passwordResetText,
    required void Function() onSuccess,
  }) async {
    _errorHandling.toggleLoadingSpinner(context);
    await _auth.resetPassword(passwordResetText: passwordResetText).then(
          (errorText) => {
            if (errorText.isNotEmpty)
              {
                _errorHandling.toggleLoadingSpinner(context),
                FocusManager.instance.primaryFocus?.unfocus(),
                addErrorMessage(errorText),
                resetErrorMessage(),
              }
            else
              {
                _errorHandling.toggleLoadingSpinner(context),
                onSuccess(),
              }
          },
        );
  }

  //recipes

  void setUserHasRecipes({required bool value}) {
    userHasRecipes = value;
    notifyListeners();
  }

  void setDeleteAll({required bool value}) {
    deleteAllRecipes = value;
    deletePrivateRecipes = !value;
    notifyListeners();
  }

  void setDeletePrivate({required bool value}) {
    deletePrivateRecipes = value;
    deleteAllRecipes = !value;
    notifyListeners();
  }
}
