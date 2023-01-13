import 'package:flutter/material.dart';

import '../../../../../domain/models/meal_model.dart';
import '../../../meals_provider.dart';

class MealCharacteristics extends StatelessWidget {
  const MealCharacteristics({
    super.key,
    required this.mealsProvider,
  });

  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              'Complexity',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Row(
              children: [
                Radio(
                  value: Complexity.easy,
                  groupValue: mealsProvider.complexity,
                  onChanged: (Complexity? complexity) {
                    mealsProvider.setComplexity(
                      selectedComplexity: complexity!,
                    );
                  },
                  activeColor: Colors.green,
                ),
                Radio(
                  value: Complexity.medium,
                  groupValue: mealsProvider.complexity,
                  onChanged: (Complexity? complexity) {
                    mealsProvider.setComplexity(
                      selectedComplexity: complexity!,
                    );
                  },
                  activeColor: Colors.orange,
                ),
                Radio(
                  value: Complexity.hard,
                  groupValue: mealsProvider.complexity,
                  onChanged: (Complexity? complexity) {
                    mealsProvider.setComplexity(
                      selectedComplexity: complexity!,
                    );
                  },
                  activeColor: Colors.red,
                ),
              ],
            )
          ],
        ),
        Column(
          children: [
            Text(
              'Public',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Switch(
              activeColor: Theme.of(context).highlightColor,
              value: mealsProvider.isPublic,
              onChanged: (bool switchPublic) {
                mealsProvider.togglePublic(
                  switchPublic: switchPublic,
                );
              },
            )
          ],
        ),
        // Column(
        //   children: [
        //     Text(
        //       'Favorite',
        //       style: Theme.of(context).textTheme.bodyText2,
        //     ),
        //     IconButton(
        //       onPressed: () {
        //         mealsProvider.toggleFavorite();
        //       },
        //       icon: Icon(
        //         Icons.favorite,
        //         color: mealsProvider.isFavorite ? Colors.red : Colors.grey,
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }
}
