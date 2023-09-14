import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/change_password.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/change_username.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/delete_account.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/logout.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/profile_info.dart';

import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:cookbook/src/core/internet_not_connected.dart';
import 'package:cookbook/src/features/theme/widgets/light_dark_switcher.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _changeUsernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmedNewPasswordController = TextEditingController();

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is ThemeLoaded) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: state.gradient,
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 5),
                            const ProfileInfo(),
                            const SizedBox(height: 15),
                            Text(
                              'Edit profile',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 5),
                            ChangeUsername(
                              changeUsernameController:
                                  _changeUsernameController,
                              isDark: state.isDarkTheme,
                            ),
                            const SizedBox(height: 5),
                            ChangePassword(
                              currentPasswordController:
                                  _currentPasswordController,
                              newPasswordController: _newPasswordController,
                              confirmedNewPasswordController:
                                  _confirmedNewPasswordController,
                              isDark: state.isDarkTheme,
                            ),
                            const SizedBox(height: 5),
                            DeleteAccount(
                              currentPasswordController:
                                  _currentPasswordController,
                              isDark: state.isDarkTheme,
                            ),
                            const Spacer(),
                            const LightDarkSwitcher(),
                            const Spacer(),
                            const LogOut(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
