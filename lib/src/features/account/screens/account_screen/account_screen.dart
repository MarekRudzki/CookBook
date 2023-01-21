import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../../core/internet_not_connected.dart';
import '../../../../domain/models/meal_model.dart';
import '../../../../core/theme_provider.dart';
import '../../../../services/firebase/auth.dart';
import '../../../../services/firebase/firestore.dart';
import '../../../../services/firebase/storage.dart';
import '../../../common_widgets/error_handling.dart';
import '../../../meals/meals_provider.dart';
import '../../account_provider.dart';
import '../login_screen/login_screen.dart';
import 'widgets/custom_alert_dialog.dart';
import 'widgets/delete_options.dart';
import 'widgets/light_dark_switcher.dart';
import 'widgets/profile_info.dart';
import 'widgets/settings_tile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _changeUsernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmedNewPasswordController = TextEditingController();

  final MealsProvider mealsProvider =
      MealsProvider(Firestore(), Auth(), Storage(), ErrorHandling());

  @override
  void dispose() {
    _changeUsernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmedNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.getGradient(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Visibility(
                  visible: Provider.of<InternetConnectionStatus>(context) ==
                      InternetConnectionStatus.disconnected,
                  child: const InternetNotConnected(),
                ),
                Visibility(
                  visible: Provider.of<InternetConnectionStatus>(context) ==
                      InternetConnectionStatus.connected,
                  child: Expanded(
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
                          ProfileInfo(
                            accountProvider: _accountProvider,
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
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    title: 'Change username?',
                                    content:
                                        'Enter new username you want to use',
                                    firstLabel: 'New username',
                                    firstController: _changeUsernameController,
                                    contentColor: Colors.blue.shade400,
                                    onConfirmed: () async {
                                      await _accountProvider.changeUsername(
                                        context: context,
                                        changeUsernameController:
                                            _changeUsernameController,
                                        onSuccess: () =>
                                            Navigator.of(context).pop(),
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
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    title: 'Change password?',
                                    content:
                                        'Please type in your current and new password',
                                    firstController: _currentPasswordController,
                                    secondController: _newPasswordController,
                                    thirdController:
                                        _confirmedNewPasswordController,
                                    firstLabel: 'Current password',
                                    secondLabel: 'New password',
                                    thirdLabel: 'Confirm new password',
                                    obscureText: true,
                                    contentColor: Colors.blue.shade400,
                                    onConfirmed: () async {
                                      _accountProvider.changePassword(
                                        context: context,
                                        currentPasswordController:
                                            _currentPasswordController,
                                        newPasswordController:
                                            _newPasswordController,
                                        confirmedNewPasswordController:
                                            _confirmedNewPasswordController,
                                        onSuccess: () =>
                                            Navigator.of(context).pop(),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          SettingsTile(
                            icon: Icons.delete_forever,
                            tileText: 'Delete account',
                            onPressed: () async {
                              final List<MealModel> userMeals =
                                  await mealsProvider.getUserMeals();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Consumer<MealsProvider>(
                                    builder: (context, mealsProvider, _) {
                                      return CustomAlertDialog(
                                        title: 'Are you sure?',
                                        content:
                                            'This action will permanently delete your account. To continue provide current password',
                                        contentColor:
                                            Theme.of(context).errorColor,
                                        firstController:
                                            _currentPasswordController,
                                        firstLabel: 'Current password',
                                        obscureText: true,
                                        additionalWidget: userMeals.isNotEmpty
                                            ? const DeleteOptions()
                                            : const SizedBox.shrink(),
                                        onConfirmed: () async {
                                          _accountProvider.deleteAccount(
                                            context: context,
                                            currentPasswordController:
                                                _currentPasswordController,
                                            mealsProvider: mealsProvider,
                                            mounted: mounted,
                                            onSuccess: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const Spacer(),
                          LightDarkSwitcher(
                            theme: theme,
                          ),
                          const Spacer(),
                          Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                _accountProvider.logOut(
                                  context: context,
                                  onSuccess: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                );
                              },
                              label: Text(
                                'Log out',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
