import 'package:flutter/material.dart';

import '../../features/meals/meals_provider.dart';
import '../../domain/models/meal_model.dart';
import '../../services/hive_services.dart';
import '../../services/firebase/auth.dart';
import '../common_widgets/error_handling.dart';
import '/src/services/firebase/firestore.dart';

class AccountProvider with ChangeNotifier {
  final ErrorHandling _errorHandling = ErrorHandling();
  final HiveServices _hiveServices = HiveServices();
  final Firestore _firestore = Firestore();
  final Auth _auth = Auth();

  String email = '';
  String username = '';
  String errorMessage = '';
  bool isCreatingAccount = false;
  bool isLoading = false;

  ///
  ////// Email
  ///

  String getEmail() {
    return _hiveServices.getUserEmail();
  }

  ///
  ////// Username
  ///

  Future<void> setUsername() async {
    await _firestore.getUsername().then((value) {
      username = value;
    });
    notifyListeners();
  }

  // Get username from firestore in case, where user created account on
  // different device and there is no username in local storage
  Future<String> getUsername() async {
    String currentUsername;
    final String savedUsername = _hiveServices.getUsername();
    if (savedUsername == 'no-username') {
      await setUsername();
      currentUsername = username;
    } else {
      currentUsername = _hiveServices.getUsername();
    }
    return currentUsername;
  }

  Future<void> changeUsername({
    required BuildContext context,
    required TextEditingController changeUsernameController,
  }) async {
    final MealsProvider _mealsProvider = MealsProvider();
    _errorHandling.toggleAccountLoadingSpinner(context);
    await _firestore.addUser(changeUsernameController.text).then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleAccountLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          addErrorMessage(message: errorText);
          resetErrorMessage();
        } else {
          _mealsProvider.updateMealAuthor(
              newUsername: changeUsernameController.text);
          _errorHandling.toggleAccountLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          username = changeUsernameController.text;
          notifyListeners();

          _hiveServices.setUsername(username: changeUsernameController.text);
          Navigator.of(context).pop();
          _errorHandling.showInfoSnackbar(
            context,
            'Username changed successfully',
            Colors.green,
          );
        }
        changeUsernameController.clear();
      },
    );
  }

  ///
  ////// Password
  ///

  Future<void> changePassword({
    required BuildContext context,
    required TextEditingController currentPasswordController,
    required TextEditingController newPasswordController,
    required TextEditingController confirmedNewPasswordController,
  }) async {
    _errorHandling.toggleAccountLoadingSpinner(context);
    _auth
        .changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      confirmedNewPassword: confirmedNewPasswordController.text,
    )
        .then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleAccountLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          addErrorMessage(message: errorText);
          resetErrorMessage();
        } else {
          _errorHandling.toggleAccountLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).pop();
          _errorHandling.showInfoSnackbar(
            context,
            'Password changed successfully',
            Colors.green,
          );
        }
      },
    );

    currentPasswordController.clear();
    newPasswordController.clear();
    confirmedNewPasswordController.clear();
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String passwordResetText,
    required void Function() onSuccess,
  }) async {
    _errorHandling.toggleAccountLoadingSpinner(context);
    await _auth.resetPassword(passwordResetText: passwordResetText).then(
          (errorText) => {
            if (errorText.isNotEmpty)
              {
                _errorHandling.toggleAccountLoadingSpinner(context),
                FocusManager.instance.primaryFocus?.unfocus(),
                addErrorMessage(message: errorText),
                resetErrorMessage(),
              }
            else
              {
                _errorHandling.toggleAccountLoadingSpinner(context),
                onSuccess(),
              }
          },
        );
  }

  ///
  ////// User register and login
  ///

  void switchLoginRegister() {
    isCreatingAccount = !isCreatingAccount;
    notifyListeners();
  }

  Future<void> logIn({
    required BuildContext context,
    required String email,
    required String password,
    required TextEditingController emailController,
    required void Function() onSuccess,
  }) async {
    _errorHandling.toggleAccountLoadingSpinner(context);

    await _auth
        .logIn(
      email: email,
      password: password,
    )
        .then(
      (errorText) {
        _errorHandling.toggleAccountLoadingSpinner(context);
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
    _errorHandling.toggleAccountLoadingSpinner(context);

    await _auth
        .register(
      email: email,
      password: password,
      username: username,
      confirmedPassword: confirmedPassword,
    )
        .then(
      (errorText) {
        _errorHandling.toggleAccountLoadingSpinner(context);
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

  ///
  ////// Delete and logOut
  ///

  Future<void> deleteAccount({
    required BuildContext context,
    required TextEditingController currentPasswordController,
    required bool mounted,
    required void Function() onSuccess,
  }) async {
    final MealsProvider _mealsProvider = MealsProvider();
    _errorHandling.toggleAccountLoadingSpinner(context);

    final List<MealModel> userMeals = await _mealsProvider.getUserMeals();
    final String uid = _auth.uid!;

    await _auth
        .validateUserPassword(password: currentPasswordController.text)
        .then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleAccountLoadingSpinner(context);
          addErrorMessage(message: errorText);
          resetErrorMessage();
          currentPasswordController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          return;
        }
      },
    );
    if (errorMessage != '') {
      return;
    }

    if (userMeals.isNotEmpty) {
      if (_mealsProvider.deleteAllRecipes) {
        await _mealsProvider.deleteMeals(deleteAll: true, userMeals: userMeals);
      } else {
        await _mealsProvider.deleteMeals(
            deleteAll: false, userMeals: userMeals);
      }
    }

    await _auth.deleteUser();
    FocusManager.instance.primaryFocus?.unfocus();
    currentPasswordController.clear();

    _hiveServices.removeUserEmail();
    _hiveServices.removeUsername();

    if (!mounted) return;
    _errorHandling.toggleAccountLoadingSpinner(context);
    isCreatingAccount = false;
    if (!mounted) return;
    onSuccess();
    await _firestore.deleteUserData(uid);
  }

  Future<void> logOut({
    required BuildContext context,
    required void Function() onSuccess,
  }) async {
    _errorHandling.toggleAccountLoadingSpinner(context);
    await _auth.signOut().then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleAccountLoadingSpinner(context);
          _errorHandling.showInfoSnackbar(context, errorText);
        } else {
          _errorHandling.toggleAccountLoadingSpinner(context);
          _hiveServices.removeUserEmail();
          isCreatingAccount = false;
          onSuccess();
        }
      },
    );
  }

  ///
  ////// Error handling
  ///

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void addErrorMessage({required String message}) {
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
