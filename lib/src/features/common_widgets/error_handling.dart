import 'package:cookbook/src/features/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorHandling {
  void showErrorSnackbar(BuildContext context, String errorText) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorText, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  void loadingSpinner(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.toggleLoading();
    context.read<LoginProvider>().isLoading
        ? showDialog(
            context: context,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          )
        : Navigator.of(context).pop();
  }
}
