import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  const Text(
                    'Difficulty',
                  ),
                  if (mealModel.complexity == 'Easy')
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, state) {
                        if (state is ThemeLoaded) {
                          return Text(
                            'Easy',
                            style: TextStyle(
                              shadows: [
                                if (state.isDarkTheme)
                                  const Shadow()
                                else
                                  const Shadow(
                                    color: Colors.white,
                                    blurRadius: 40,
                                  )
                              ],
                              color: state.isDarkTheme
                                  ? Colors.green
                                  : const Color.fromARGB(255, 49, 138, 52),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
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
                      const Text(
                        'Author',
                      ),
                      Text(mealModel.mealAuthor)
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context
                      .read<MealsBloc>()
                      .add(ToggleMealFavoritePressed(mealId: mealModel.id));
                },
                icon: BlocBuilder<MealsBloc, MealsState>(
                  builder: (context, state) {
                    if (state is UserFavoriteMealsIdLoaded) {
                      final bool isFavorite =
                          state.mealsId.contains(mealModel.id);
                      return Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.red : Colors.white,
                      );
                    } else
                      return const Icon(
                        Icons.favorite,
                        color: Colors.grey,
                      );
                  },
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Divider(
            height: 2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
