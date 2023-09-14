import 'package:cookbook/src/core/constants.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/change_username/change_username_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/settings_tile.dart';
import 'package:cookbook/src/features/common_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChangeUsername extends StatelessWidget {
  const ChangeUsername({
    super.key,
    required this.changeUsernameController,
    required this.isDark,
  });

  final TextEditingController changeUsernameController;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: Icons.edit,
      tileText: 'Change username',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Change username?',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              content: const Text(
                softWrap: true,
                'Enter new username you want to use',
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
                    BlocConsumer<ChangeUsernameBloc, ChangeUsernameState>(
                      listener: (context, state) {
                        if (state is ChangeUsernameSuccess) {
                          context.read<AuthBloc>().add(UsernameRequested());
                          changeUsernameController.clear();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(CustomSnackbar.showSnackBar(
                            message: 'Username changed successfully',
                            backgroundColor: Colors.green,
                          ));
                        }
                      },
                      builder: (context, state) {
                        if (state is ChangeUsernameLoading) {
                          return const SpinKitThreeBounce(
                            size: 25,
                            color: Colors.white,
                          );
                        } else {
                          return TextField(
                            controller: changeUsernameController,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              label: Center(
                                child: Text(
                                  'New username',
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
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child:
                          BlocBuilder<ChangeUsernameBloc, ChangeUsernameState>(
                        builder: (context, state) {
                          if (state is ChangeUsernameError) {
                            return Text(
                              state.errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 14,
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            context.read<ChangeUsernameBloc>().add(
                                  ChangeUsernamePressed(
                                      newUsername:
                                          changeUsernameController.text.trim()),
                                );
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            changeUsernameController.clear();
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
