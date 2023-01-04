import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../../core/theme_provider.dart';
import '../../../../../core/constants.dart';
import '../../../account_provider.dart';

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
    final ThemeProvider _themeProvider = ThemeProvider();
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      ),
      content: Text(
        softWrap: true,
        content,
        style: TextStyle(
          color: contentColor,
        ),
      ),
      backgroundColor: _themeProvider.isDark() ? kLightBlue : kLightGreen,
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
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyText1,
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
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyText1,
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
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: context.select((AccountProvider provider) =>
                          provider.errorMessage) !=
                      ''
                  ? Text(
                      _accountProvider.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
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
