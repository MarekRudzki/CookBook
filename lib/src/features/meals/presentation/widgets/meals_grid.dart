import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meal_item.dart';
import 'package:flutter/material.dart';

class MealsGrid extends StatelessWidget {
  const MealsGrid({
    super.key,
    this.textIfEmpty = '',
    required this.mealData,
  });

  final String textIfEmpty;
  final List<MealModel> mealData;

  @override
  Widget build(BuildContext context) {
    if (mealData.isEmpty) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              textIfEmpty,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            return MealItem(
              mealModel: mealData[index],
            );
          },
          itemCount: mealData.length,
        ),
      );
    }
  }
}
