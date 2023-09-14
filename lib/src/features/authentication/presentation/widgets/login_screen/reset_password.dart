import 'package:cookbook/src/features/authentication/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:flutter/material.dart';

import 'package:cookbook/src/core/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        textAlign: TextAlign.center,
        'Reset your password?',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: const Text(
        textAlign: TextAlign.center,
        softWrap: true,
        'Enter the email adress associated with your account',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: kDarkModeLighter,
      actions: [
        Column(
          children: [
            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                label: const Center(
                  child: Text('Input your email'),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            BlocBuilder<PasswordResetBloc, PasswordResetState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: state is PasswordResetError
                      ? Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
            BlocConsumer<PasswordResetBloc, PasswordResetState>(
              listener: (context, state) {
                if (state is PasswordResetSuccess) {
                  Navigator.of(context).pop();
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
                        backgroundColor: kDarkModeLighter,
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
                  );
                }
              },
              builder: (context, state) {
                if (state is PasswordResetLoading) {
                  return const SpinKitThreeBounce(
                    size: 25,
                    color: Colors.white,
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<PasswordResetBloc>().add(
                              PasswordResetPressed(
                                  passwordResetEmail: controller.text.trim()));
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.clear();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
