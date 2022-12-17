import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../account/cubit/account_cubit.dart';
import '../common_widgets/error_handling.dart';

class CustromAlertDialog extends StatelessWidget {
  const CustromAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.labelText,
    required this.controller,
    required this.functionTryCatch,
    this.additionalFunction,
  });

  final String title;
  final String content;
  final String labelText;
  final TextEditingController controller;
  final Future<String> functionTryCatch;
  final Function()? additionalFunction;

  @override
  Widget build(BuildContext context) {
    final accountCubit = BlocProvider.of<AccountCubit>(context);
    final ErrorHandling _errorHandling = ErrorHandling();
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      content: Text(
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
              child: BlocBuilder<AccountCubit, AccountState>(
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
                    _errorHandling.loadingSpinner(context);
                    await functionTryCatch.then(
                      (errorText) => {
                        print(
                            errorText), //TODO handle no error message in psw reset
                        if (errorText.isNotEmpty)
                          {
                            _errorHandling.loadingSpinner(context),
                            FocusManager.instance.primaryFocus?.unfocus(),
                            accountCubit.addErrorMessage(errorText),
                            accountCubit.clearErrorMessage(),
                          }
                        else
                          {
                            _errorHandling.loadingSpinner(context),
                            Navigator.of(context).pop(),
                            additionalFunction,
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
                    controller.clear();
                    accountCubit.addErrorMessage('');
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
