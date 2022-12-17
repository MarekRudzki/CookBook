import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../account/cubit/account_cubit.dart';

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
    final accountCubit = BlocProvider.of<AccountCubit>(context);
    accountCubit.switchLoading();
    accountCubit.state.isLoading
        ? showDialog(
            context: context,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          )
        : Navigator.of(context).pop();
  }
}
