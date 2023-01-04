import 'package:flutter/material.dart';

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:provider/provider.dart';

import '../../../../services/firebase/firestore.dart';
import '../../../../services/firebase/auth.dart';
import '../../../../services/hive_services.dart';
import '../../../../core/theme_provider.dart';
import '../../../../core/constants.dart';
import '../../../common_widgets/error_handling.dart';
import '../../account_provider.dart';
import '../login_screen/login_screen.dart';
import 'widgets/custom_alert_dialog.dart';
import 'widgets/settings_tile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final TextEditingController _changeUsernameConroller;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmedNewPasswordController;

  final ErrorHandling _errorHandling = ErrorHandling();
  final HiveServices _hiveServices = HiveServices();
  final Firestore _firestore = Firestore();
  final Auth _auth = Auth();
  String? username;

  @override
  void initState() {
    super.initState();
    _changeUsernameConroller = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmedNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _changeUsernameConroller.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmedNewPasswordController.dispose();
    super.dispose();
  }

  // Get username from firestore in case, where user created account on
  // different device and there is no username in local storage
  //TODO check if this works
  Future<bool> setUsername({required AccountProvider accountProvider}) async {
    if (_hiveServices.getUsername() != null) {
      username = _hiveServices.getUsername();
    } else {
      await accountProvider.setUsername();
      username = accountProvider.username;
    }
    return true;
  }

  Future<void> changeUsername(
      {required AccountProvider accountProvider}) async {
    _errorHandling.toggleLoadingSpinner(context);
    await _firestore.addUser(_changeUsernameConroller.text).then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          accountProvider.addErrorMessage(errorText);
          accountProvider.resetErrorMessage();
        } else {
          _errorHandling.toggleLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          accountProvider.changeUsername(
            _changeUsernameConroller.text,
          );
          _hiveServices.setUsername(username: _changeUsernameConroller.text);
          Navigator.of(context).pop();
          _errorHandling.showInfoSnackbar(
            context,
            'Username changed successfully',
            Colors.green,
          );
        }
        _changeUsernameConroller.clear();
      },
    );
  }

  Future<void> changePassword(
      {required AccountProvider accountProvider}) async {
    _errorHandling.toggleLoadingSpinner(context);
    _auth
        .changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmedNewPassword: _confirmedNewPasswordController.text,
    )
        .then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          accountProvider.addErrorMessage(errorText);
          accountProvider.resetErrorMessage();
        } else {
          _errorHandling.toggleLoadingSpinner(context);
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

    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmedNewPasswordController.clear();
  }

  Future<void> deleteAccount({required AccountProvider accountProvider}) async {
    final String uid = _auth.uid!;
    _errorHandling.toggleLoadingSpinner(context);
    await _auth.deleteUser(password: _currentPasswordController.text).then(
      (errorText) async {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleLoadingSpinner(context);
          accountProvider.addErrorMessage(errorText);
          accountProvider.resetErrorMessage();
          _currentPasswordController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        _currentPasswordController.clear();
        _errorHandling.toggleLoadingSpinner(context);
        _hiveServices.removeUser();
        _hiveServices.removeUsername();

        accountProvider.isCreatingAccount = false;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        await _firestore.deleteUserData(uid);
      },
    );
  }

  Future<void> logOut({required AccountProvider accountProvider}) async {
    _errorHandling.toggleLoadingSpinner(context);
    await _auth.signOut().then((errorText) {
      if (errorText.isNotEmpty) {
        _errorHandling.toggleLoadingSpinner(context);
        _errorHandling.showInfoSnackbar(context, errorText);
      } else {
        _errorHandling.toggleLoadingSpinner(context);
        _hiveServices.removeUser();
        accountProvider.isCreatingAccount = false;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _accountProvider =
        Provider.of<AccountProvider>(context, listen: false);

    return Consumer<ThemeProvider>(
      builder: (context, theme, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.getGradient(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Consumer<AccountProvider>(
                                builder: (context, value, child) {
                                  return FutureBuilder(
                                    future: setUsername(
                                      accountProvider: _accountProvider,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          'Username: $username',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.mail,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'Email: ${_hiveServices.getEmail()}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Edit profile',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(height: 5),
                  SettingsTile(
                    icon: Icons.edit,
                    tileText: 'Change username',
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            title: 'Change username?',
                            content: 'Enter new username you want to use',
                            firstLabel: 'Input new username',
                            firstController: _changeUsernameConroller,
                            onConfirmed: () async {
                              await changeUsername(
                                accountProvider: _accountProvider,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  SettingsTile(
                    icon: Icons.key,
                    tileText: 'Change password',
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                              title: 'Change password?',
                              content:
                                  'Please type in your current and new password',
                              firstController: _currentPasswordController,
                              secondController: _newPasswordController,
                              thirdController: _confirmedNewPasswordController,
                              firstLabel: 'Current password',
                              secondLabel: 'New password',
                              thirdLabel: 'Confirm new password',
                              obscureText: true,
                              onConfirmed: () async {
                                await changePassword(
                                  accountProvider: _accountProvider,
                                );
                              });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  SettingsTile(
                    icon: Icons.delete_forever,
                    tileText: 'Delete account',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            title: 'Are you sure?',
                            content:
                                'This action will permanently delete your account. To continue provide current password',
                            contentColor: Theme.of(context).errorColor,
                            firstController: _currentPasswordController,
                            firstLabel: 'Current password',
                            obscureText: true,
                            onConfirmed: () async {
                              deleteAccount(
                                accountProvider: _accountProvider,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Light',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        child: Center(
                          child: DayNightSwitcher(
                            nightBackgroundColor: kLightBlue.withBlue(180),
                            isDarkModeEnabled: theme.isDark(),
                            onStateChanged: (_) {
                              theme.swapTheme();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dark',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        logOut(
                          accountProvider: _accountProvider,
                        );
                      },
                      label: Text(
                        'Log out',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
