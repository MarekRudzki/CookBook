import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../domain/models/meal_model.dart';
import '../../../meals_provider.dart';
import 'meal_item.dart';

class MealsGrid extends StatelessWidget {
  const MealsGrid({
    super.key,
    required this.mealsProvider,
    required this.future,
    this.textIfEmpty = '',
  });

  final MealsProvider mealsProvider;
  final Future<List<MealModel>> future;
  final String textIfEmpty;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 25,
              ),
            ),
          );
        }

        if (snapshot.data!.isEmpty) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  textIfEmpty,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
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
                  mealModel: snapshot.data![index],
                );
              },
              itemCount: snapshot.data!.length,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
