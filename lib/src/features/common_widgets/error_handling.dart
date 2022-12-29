import 'package:cookbook/src/features/meals/meals_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../account/account_provider.dart';

class ErrorHandling {
  void showErrorSnackbar(BuildContext context, String errorText) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  void toggleLoadingSpinner(BuildContext context) {
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    accountProvider.toggleLoading();
    context.read<AccountProvider>().isLoading
        ? showDialog(
            context: context,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          )
        : Navigator.of(context).pop();
  }

  void toggleRecipeLoadingSpinner(BuildContext context) {
    final mealsProvider = Provider.of<MealsProvider>(context, listen: false);
    mealsProvider.toggleLoading();
    context.read<MealsProvider>().isLoading
        ? showDialog(
            context: context,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          )
        : Navigator.of(context).pop();
  }
}
