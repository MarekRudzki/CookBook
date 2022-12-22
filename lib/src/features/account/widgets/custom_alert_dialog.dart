import 'package:cookbook/src/features/account/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirmed,
    this.contentColor = Colors.white,
    this.obscureText = false,
    this.firstLabel,
    this.secondLabel,
    this.thirdLabel,
    this.firstController,
    this.secondController,
    this.thirdController,
  });

  final String title;
  final String content;
  final Color contentColor;
  final bool obscureText;
  final Function() onConfirmed;
  final TextEditingController? firstController;
  final TextEditingController? secondController;
  final TextEditingController? thirdController;
  final String? firstLabel;
  final String? secondLabel;
  final String? thirdLabel;

  @override
  Widget build(BuildContext context) {
    final _accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      content: Text(
        softWrap: true,
        content,
        style: TextStyle(
          color: contentColor,
        ),
      ),
      backgroundColor: kLighterBlue,
      actions: [
        Column(
          children: [
            if (firstLabel != null)
              TextField(
                controller: firstController,
                textAlign: TextAlign.center,
                obscureText: obscureText,
                decoration: InputDecoration(
                  label: Center(
                    child: Text(firstLabel!),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
                style: const TextStyle(color: Colors.white70),
              ),
            if (secondLabel != null)
              TextField(
                controller: secondController,
                textAlign: TextAlign.center,
                obscureText: obscureText,
                decoration: InputDecoration(
                  label: Center(
                    child: Text(secondLabel!),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
                style: const TextStyle(color: Colors.white70),
              ),
            if (thirdLabel != null)
              TextField(
                controller: thirdController,
                textAlign: TextAlign.center,
                obscureText: obscureText,
                decoration: InputDecoration(
                  label: Center(
                    child: Text(thirdLabel!),
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
                  onPressed: onConfirmed,
                  icon: const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    if (firstController != null) {
                      firstController!.clear();
                    }
                    if (secondController != null) {
                      secondController!.clear();
                    }
                    if (thirdController != null) {
                      thirdController!.clear();
                    }
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
  }
}
