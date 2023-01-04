import 'package:cookbook/src/core/theme_provider.dart';
import 'package:cookbook/src/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/meals_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.mealModel,
  });

  final MealModel mealModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeProvider.getGradient(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: FutureBuilder(
                future: Provider.of<MealsProvider>(context, listen: false)
                    .getFavoritesMealsId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 56, 8),
                                child: Align(
                                  child: Text(
                                    mealModel.name,
                                    softWrap: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                          fontSize: 22,
                                        ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                backgroundColor: Colors.transparent,
                                expandedHeight:
                                    MediaQuery.of(context).size.height * 0.4,
                                leading: const SizedBox.shrink(),
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Hero(
                                    tag: mealModel.id,
                                    child: Image.network(
                                      fit: BoxFit.cover,
                                      mealModel.imageUrl,
                                    ),
                                  ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    MealCharacteristics(
                                      mealModel: mealModel,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 25),
                                      child: Divider(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class MealCharacteristics extends StatelessWidget {
  const MealCharacteristics({
    super.key,
    required this.mealModel,
  });

  final MealModel mealModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
