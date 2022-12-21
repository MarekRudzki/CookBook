import 'package:cookbook/src/features/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../services/firebase/auth.dart';
import '../../common_widgets/custom_alert_dialog.dart';
import '../../common_widgets/error_handling.dart';

void resetPassword(BuildContext context, TextEditingController controller) {
  final Auth _auth = Auth();
  final ErrorHandling _errorHandling = ErrorHandling();
  final loginProvider = Provider.of<LoginProvider>(context, listen: false);
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return CustromAlertDialog(
        title: 'Reset your password?',
        content: 'Enter the email adress associated with your account',
        labelText: 'Input your email',
        controller: controller,
        onConfirmed: () async {
          _errorHandling.loadingSpinner(context);
          _auth
              .resetPassword(
                passwordResetText: controller.text.trim(),
              )
              .then(
                (errorText) => {
                  if (errorText.isNotEmpty)
                    {
                      _errorHandling.loadingSpinner(context),
                      FocusManager.instance.primaryFocus?.unfocus(),
                      loginProvider.addErrorMessage(errorText),
                      loginProvider.resetErrorMessage(),
                    }
                  else
                    {
                      _errorHandling.loadingSpinner(context),
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
                      ),
                    }
                },
              );
        },
      );
    },
  );
}
