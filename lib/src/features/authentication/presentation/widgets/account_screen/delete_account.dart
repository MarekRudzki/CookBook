import 'package:cookbook/src/core/constants.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/delete_account/delete_account_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/screens/login_screen.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/delete_options.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/account_screen/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({
    super.key,
    required this.isDark,
    required this.currentPasswordController,
  });
  final bool isDark;
  final TextEditingController currentPasswordController;

  @override
  Widget build(BuildContext context) {
    context.read<DeleteAccountBloc>().add(UserMealsCheck());
    return SettingsTile(
      icon: Icons.delete_forever,
      tileText: 'Delete account',
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Are you sure?',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              content: Text(
                softWrap: true,
                'This action will permanently delete your account. To continue provide current password',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: isDark
                  ? kDarkModeLighter
                  : Theme.of(context).colorScheme.onBackground,
              actions: [
                Column(
                  children: [
                    BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
                      listener: (context, state) {
                        if (state is DeleteAccountSuccess) {
                          currentPasswordController.clear();
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is DeleteAccountLoading) {
                          return const SpinKitThreeBounce(
                            size: 25,
                            color: Colors.white,
                          );
                        } else {
                          return TextField(
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
                              ));
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
                        builder: (context, state) {
                          if (state is DeleteAccountError) {
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
                    BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
                      builder: (context, state) {
                        if (state is DeleteAccountInitial) {
                          if (state.userHasMeals) {
                            return const DeleteOptions();
                          } else if (state is DeleteAccountLoading) {
                            return const SpinKitThreeBounce(
                              size: 25,
                              color: Colors.white,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
                          builder: (context, state) {
                            if (state is DeleteAccountInitial) {
                              return IconButton(
                                onPressed: () async {
                                  context
                                      .read<DeleteAccountBloc>()
                                      .add(DeleteAccountPressed(
                                        password: currentPasswordController.text
                                            .trim(),
                                        deleteAllRecipes:
                                            state.deleteAllRecipes,
                                      ));
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            currentPasswordController.clear();
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
