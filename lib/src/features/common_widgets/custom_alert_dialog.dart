import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../login/cubit/login_cubit.dart';

class CustromAlertDialog extends StatelessWidget {
  const CustromAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.labelText,
    required this.controller,
    required this.onConfirmed,
  });

  final String title;
  final String content;
  final String labelText;
  final TextEditingController controller;
  final Function() onConfirmed;

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    return AlertDialog(
      title: Text(
        textAlign: TextAlign.center,
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      content: Text(
        textAlign: TextAlign.center,
        softWrap: true,
        content,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: kLighterBlue,
      actions: [
        Column(
          children: [
            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                label: Center(
                  child: Text(labelText),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
              style: const TextStyle(color: Colors.white70),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<LoginCubit, LoginState>(
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
                  onPressed: onConfirmed,
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.clear();
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
