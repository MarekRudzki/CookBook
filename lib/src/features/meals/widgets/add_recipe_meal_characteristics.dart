import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../domain/models/meal_model.dart';
import '../meals_provider.dart';

class MealCharacteristics extends StatelessWidget {
  const MealCharacteristics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MealsProvider>(
      builder: (context, meals, child) {
        final Complexity complexity = meals.complexity;
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
                      value: Complexity.simple,
                      groupValue: complexity,
                      onChanged: (Complexity? complexity) {
                        meals.setComplexity(
                          selectedComplexity: complexity!,
                        );
                      },
                      activeColor: Colors.green,
                    ),
                    Radio(
                      value: Complexity.challenging,
                      groupValue: complexity,
                      onChanged: (Complexity? complexity) {
                        meals.setComplexity(
                          selectedComplexity: complexity!,
                        );
                      },
                      activeColor: Colors.orange,
                    ),
                    Radio(
                      value: Complexity.hard,
                      groupValue: complexity,
                      onChanged: (Complexity? complexity) {
                        meals.setComplexity(
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
                  value: meals.isPublic,
                  onChanged: (bool switchPublic) {
                    meals.togglePublic(
                      switchPublic: switchPublic,
                    );
                  },
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Favorite',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                IconButton(
                  onPressed: () {
                    meals.toggleFavorite();
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: meals.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
