import 'package:cookbook/src/core/theme_provider.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_alert_dialog.dart';
import '../../../core/constants.dart';
import '../../../services/firebase/auth.dart';
import '../../../services/shared_prefs.dart';
import '../../common_widgets/error_handling.dart';
import 'login_screen.dart';
import '../account_provider.dart';
import '../widgets/settings_tile.dart';
import '/src/services/firebase/firestore.dart';

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
  final Auth _auth = Auth();
  final SharedPrefs _sharedPrefs = SharedPrefs();
  final ErrorHandling _errorHandling = ErrorHandling();
  final Firestore _firestore = Firestore();

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

  @override
  Widget build(BuildContext context) {
    final _accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: GoogleFonts.oswald(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Username: ${context.select((AccountProvider provider) => provider.username)}',
                          style: GoogleFonts.robotoSlab(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Email: ${_auth.email}',
                          style: GoogleFonts.robotoSlab(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Edit profile',
              style: GoogleFonts.oswald(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
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
                        _errorHandling.toggleLoadingSpinner(context);
                        await _firestore
                            .addUser(_changeUsernameConroller.text)
                            .then(
                          (errorText) {
                            if (errorText.isNotEmpty) {
                              _errorHandling.toggleLoadingSpinner(context);
                              FocusManager.instance.primaryFocus?.unfocus();
                              _accountProvider.addErrorMessage(errorText);
                              _accountProvider.resetErrorMessage();
                            } else {
                              _errorHandling.toggleLoadingSpinner(context);
                              FocusManager.instance.primaryFocus?.unfocus();
                              _accountProvider.changeUsername(
                                _changeUsernameConroller.text,
                              );
                              Navigator.of(context).pop();
                            }
                            _changeUsernameConroller.clear();
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
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
                      content: 'Please type in your current and new password',
                      firstController: _currentPasswordController,
                      secondController: _newPasswordController,
                      thirdController: _confirmedNewPasswordController,
                      firstLabel: 'Current password',
                      secondLabel: 'New password',
                      thirdLabel: 'Confirm new password',
                      obscureText: true,
                      onConfirmed: () async {
                        _errorHandling.toggleLoadingSpinner(context);
                        _auth
                            .changePassword(
                          currentPassword: _currentPasswordController.text,
                          newPassword: _newPasswordController.text,
                          confirmedNewPassword:
                              _confirmedNewPasswordController.text,
                        )
                            .then((errorText) {
                          if (errorText.isNotEmpty) {
                            _errorHandling.toggleLoadingSpinner(context);
                            FocusManager.instance.primaryFocus?.unfocus();
                            _accountProvider.addErrorMessage(errorText);
                            _accountProvider.resetErrorMessage();
                          } else {
                            _errorHandling.toggleLoadingSpinner(context);
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.of(context).pop();
                          }
                        });

                        _currentPasswordController.clear();
                        _newPasswordController.clear();
                        _confirmedNewPasswordController.clear();
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
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
                      contentColor: Colors.red,
                      firstController: _currentPasswordController,
                      firstLabel: 'Current password',
                      obscureText: true,
                      onConfirmed: () async {
                        final String uid = _auth.uid!;
                        _errorHandling.toggleLoadingSpinner(context);
                        await _auth
                            .deleteUser(
                                password: _currentPasswordController.text)
                            .then(
                          (errorText) async {
                            if (errorText.isNotEmpty) {
                              _errorHandling.toggleLoadingSpinner(context);
                              _accountProvider.addErrorMessage(errorText);
                              _accountProvider.resetErrorMessage();
                              _currentPasswordController.clear();
                              FocusManager.instance.primaryFocus?.unfocus();
                              return;
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            _currentPasswordController.clear();
                            _errorHandling.toggleLoadingSpinner(context);
                            _sharedPrefs.removeUser();

                            _accountProvider.isCreatingAccount = false;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                            await _firestore.deleteUserData(uid);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            const Spacer(),
            SizedBox(
              child: Center(
                child: DayNightSwitcher(
                  isDarkModeEnabled: context.select(
                    (ThemeProvider theme) => theme.isDark(),
                  ),
                  onStateChanged: (_) {
                    _themeProvider.swapTheme();
                  },
                ),
              ),
            ),
            Center(
              child: Text(
                '${_themeProvider.isDark() ? 'Dark' : 'Light'} theme is enabled',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kLighterBlue,
                ),
                onPressed: () async {
                  _errorHandling.toggleLoadingSpinner(context);
                  await _auth.signOut().then((errorText) {
                    if (errorText.isNotEmpty) {
                      _errorHandling.toggleLoadingSpinner(context);
                      _errorHandling.showErrorSnackbar(context, errorText);
                    } else {
                      _errorHandling.toggleLoadingSpinner(context);
                      _sharedPrefs.removeUser();
                      _accountProvider.isCreatingAccount = false;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  });
                },
                label: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
