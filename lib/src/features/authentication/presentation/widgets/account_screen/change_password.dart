import 'package:cookbook/src/core/constants.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/change_password/change_password_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/settings_tile.dart';
import 'package:cookbook/src/features/common_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({
    super.key,
    required this.isDark,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmedNewPasswordController,
  });
  final bool isDark;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmedNewPasswordController;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: Icons.key,
      tileText: 'Change password',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Change password?',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              content: const Text(
                softWrap: true,
                'Please type in your current and new password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              backgroundColor: isDark
                  ? kDarkModeLighter
                  : Theme.of(context).colorScheme.onBackground,
              actions: [
                Column(
                  children: [
                    BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                      listener: (context, state) {
                        if (state is ChangePasswordSuccess) {
                          currentPasswordController.clear();
                          newPasswordController.clear();
                          confirmedNewPasswordController.clear();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(CustomSnackbar.showSnackBar(
                            message: 'Password changed successfully',
                            backgroundColor: Colors.green,
                          ));
                        }
                      },
                      builder: (context, state) {
                        if (state is ChangePasswordLoading) {
                          return const SpinKitThreeBounce(
                            size: 25,
                            color: Colors.white,
                          );
                        } else {
                          return Column(
                            children: [
                              TextField(
                                controller: currentPasswordController,
                                textAlign: TextAlign.center,
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  label: Center(
                                    child: Text(
                                      'Current password',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TextField(
                                controller: newPasswordController,
                                textAlign: TextAlign.center,
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  label: Center(
                                    child: Text(
                                      'New password',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TextField(
                                controller: confirmedNewPasswordController,
                                textAlign: TextAlign.center,
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  label: Center(
                                    child: Text(
                                      'Confirm new password',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: BlocBuilder<ChangePasswordBloc,
                                    ChangePasswordState>(
                                  builder: (context, state) {
                                    if (state is ChangePasswordError) {
                                      return Text(
                                        state.errorMessage,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          fontSize: 14,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            context
                                .read<ChangePasswordBloc>()
                                .add(ChangePasswordPressed(
                                  currentPassword:
                                      currentPasswordController.text.trim(),
                                  newPassword:
                                      newPasswordController.text.trim(),
                                  confirmedNewPassword:
                                      confirmedNewPasswordController.text
                                          .trim(),
                                ));
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            currentPasswordController.clear();
                            newPasswordController.clear();
                            confirmedNewPasswordController.clear();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
