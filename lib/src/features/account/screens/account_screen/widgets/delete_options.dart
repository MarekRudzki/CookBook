import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../meals/meals_provider.dart';

class DeleteOptions extends StatelessWidget {
  const DeleteOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MealsProvider>(
      builder: (context, mealsProvider, _) {
        if (mealsProvider.userHasRecipes) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Delete only private recipes',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          )),
                  Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const BorderSide(color: Colors.red);
                        } else {
                          return const BorderSide(color: Colors.grey);
                        }
                      }),
                      value: mealsProvider.deletePrivateRecipes,
                      onChanged: (value) {
                        mealsProvider.setDeletePrivate(value: value!);
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Delete all my recipes',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context).primaryColorDark,
                          )),
                  Checkbox(
                      side: MaterialStateBorderSide.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const BorderSide(color: Colors.red);
                        } else {
                          return const BorderSide(color: Colors.grey);
                        }
                      }),
                      value: mealsProvider.deleteAllRecipes,
                      onChanged: (value) {
                        mealsProvider.setDeleteAll(value: value!);
                      }),
                ],
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
