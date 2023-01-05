import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../../domain/models/meal_model.dart';
import '../../../meals_provider.dart';

class DetailsMealCharacteristics extends StatelessWidget {
  const DetailsMealCharacteristics({
    super.key,
    required this.mealModel,
  });

  final MealModel mealModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Difficulty:',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  if (mealModel.complexity == 'Easy')
                    const Text(
                      'Easy',
                      style: TextStyle(color: Colors.green),
                    )
                  else
                    mealModel.complexity == 'Medium'
                        ? const Text(
                            'Medium',
                            style: TextStyle(color: Colors.orange),
                          )
                        : const Text(
                            'Hard',
                            style: TextStyle(color: Colors.red),
                          ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Author:',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(mealModel.mealAuthor)
                    ],
                  ),
                ],
              ),
              Consumer<MealsProvider>(
                builder: (context, meals, _) {
                  return IconButton(
                    onPressed: () async {
                      await meals.toggleMealFavorite(mealModel.id);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: meals.favoritesId.contains(mealModel.id)
                          ? Colors.red
                          : Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Divider(
            height: 2,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
