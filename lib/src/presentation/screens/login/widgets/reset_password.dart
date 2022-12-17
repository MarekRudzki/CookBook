import 'package:cookbook/src/services/firebase/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants.dart';
import '../cubit/login_screen_cubit.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({
    super.key,
    required this.passwordResetController,
    required this.loadingSpinner,
  });

  final TextEditingController passwordResetController;
  final void Function(BuildContext) loadingSpinner;

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginScreenCubit>(context);
    final Auth _auth = Auth();
    return AlertDialog(
      title: const Text(
        'Reset your password?',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: const Text(
        'Enter the email adress associated with your account',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: kLighterBlue,
      actions: [
        Column(
          children: [
            TextField(
              controller: passwordResetController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                label: const Center(
                  child: Text('Input your email'),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
              style: const TextStyle(color: Colors.white70),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<LoginScreenCubit, LoginScreenState>(
                builder: (context, state) {
                  return state.errorMessage != ''
                      ? Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    loadingSpinner(context);
                    await _auth
                        .resetPassword(
                            passwordResetText: passwordResetController.text)
                        .then(
                          (errorText) => {
                            if (errorText.isNotEmpty)
                              {
                                loadingSpinner(context),
                                FocusManager.instance.primaryFocus?.unfocus(),
                                loginCubit.addErrorMessage(errorText),
                                loginCubit.clearErrorMessage(),
                              }
                            else
                              {
                                loadingSpinner(context),
                                Navigator.of(context).pop(),
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Check your mailbox',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      content: const Text(
                                        'You should find link to reset your password in your mailbox.',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      backgroundColor: kLighterBlue,
                                      actions: [
                                        Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              }
                          },
                        );
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    passwordResetController.clear();
                    loginCubit.addErrorMessage('');
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
  }
}
