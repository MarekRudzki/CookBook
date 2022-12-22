import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../services/firebase/auth.dart';
import '../../common_widgets/error_handling.dart';
import '../account_provider.dart';

void resetPassword(BuildContext context, TextEditingController controller) {
  final _accountProvider = Provider.of<AccountProvider>(context, listen: false);
  final ErrorHandling _errorHandling = ErrorHandling();
  final Auth _auth = Auth();

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          textAlign: TextAlign.center,
          'Reset your password?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: const Text(
          textAlign: TextAlign.center,
          softWrap: true,
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
                style: const TextStyle(color: Colors.white70),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: context.select((AccountProvider provider) =>
                            provider.errorMessage) !=
                        ''
                    ? Text(
                        _accountProvider.errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      _errorHandling.toggleLoadingSpinner(context);
                      _auth
                          .resetPassword(
                            passwordResetText: controller.text.trim(),
                          )
                          .then(
                            (errorText) => {
                              if (errorText.isNotEmpty)
                                {
                                  _errorHandling.toggleLoadingSpinner(context),
                                  FocusManager.instance.primaryFocus?.unfocus(),
                                  _accountProvider.addErrorMessage(errorText),
                                  _accountProvider.resetErrorMessage(),
                                }
                              else
                                {
                                  _errorHandling.toggleLoadingSpinner(context),
                                  Navigator.of(context).pop(),
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Check your mailbox',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                        content: const Text(
                                          'You should find link to reset your password in your mailbox.',
                                          style:
                                              TextStyle(color: Colors.white70),
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
                                  ),
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
                      _accountProvider.addErrorMessage('');
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
}
