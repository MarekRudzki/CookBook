import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../domain/models/meal_model.dart';
import '../../../../core/theme_provider.dart';
import '../edit_meal_screen/edit_meal_screen.dart';
import '../../meals_provider.dart';
import 'widgets/details_meal_characteristics.dart';
import 'widgets/meal_element.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.mealModel,
    required this.mealsProvider,
  });

  final MealModel mealModel;
  final MealsProvider mealsProvider;

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
                                padding: mealsProvider
                                        .checkIfAuthor(mealModel.authorId)
                                    ? const EdgeInsets.fromLTRB(8, 8, 8, 8)
                                    : const EdgeInsets.fromLTRB(8, 8, 56, 8),
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
                            ),
                            if (mealsProvider.checkIfAuthor(mealModel.authorId))
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditMealScreen(
                                        mealModel: mealModel,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                          ],
                        ),
                        Expanded(
                          child: NestedScrollView(
                            headerSliverBuilder: (context, innerBoxIsScrolled) {
                              return [
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
                              ];
                            },
                            body: SingleChildScrollView(
                              child: Column(
                                children: [
                                  DetailsMealCharacteristics(
                                    mealModel: mealModel,
                                  ),
                                  Center(
                                    child: Text(
                                      'Ingredients',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return MealElement(
                                        elementText: mealModel
                                            .ingredients[index] as String,
                                      );
                                    },
                                    itemCount: mealModel.ingredients.length,
                                  ),
                                  Center(
                                    child: Text(
                                      'Description',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return MealElement(
                                        elementText: mealModel
                                            .description[index] as String,
                                      );
                                    },
                                    itemCount: mealModel.description.length,
                                  ),
                                ],
                              ),
                            ),
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
