import 'package:cookbook/src/features/authentication/presentation/blocs/delete_account/delete_account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DeleteOptions extends StatelessWidget {
  const DeleteOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
      builder: (context, state) {
        if (state is DeleteAccountInitial) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Delete only private recipes',
                  ),
                  Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const BorderSide(color: Colors.red);
                        } else {
                          return const BorderSide(color: Colors.grey);
                        }
                      }),
                      value: !state.deleteAllRecipes,
                      onChanged: (value) {
                        context.read<DeleteAccountBloc>().add(
                            DeleteMealsOptionChanged(deleteAllRecipes: false));
                      }),
                  const SizedBox(height: 10),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Delete all my recipes',
                  ),
                  Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const BorderSide(color: Colors.red);
                        } else {
                          return const BorderSide(color: Colors.grey);
                        }
                      }),
                      value: state.deleteAllRecipes,
                      onChanged: (value) {
                        context.read<DeleteAccountBloc>().add(
                            DeleteMealsOptionChanged(deleteAllRecipes: true));
                      }),
                ],
              ),
            ],
          );
        } else {
          return const SpinKitThreeBounce(
            size: 25,
            color: Colors.white,
          );
        }
      },
    );
  }
}
