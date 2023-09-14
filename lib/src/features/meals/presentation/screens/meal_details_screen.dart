import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/screens/edit_meal_screen.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/details_meal_characteristics.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meal_element.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.mealModel,
  });

  final MealModel mealModel;

  @override
  Widget build(BuildContext context) {
    context.read<MealsBloc>().add(UserFavoriteMealsIdRequested());
    final bool isAuthor =
        context.read<MealsBloc>().checkIfAuthor(authorId: mealModel.authorId);
    return WillPopScope(
      onWillPop: () {
        context
            .read<MealsBloc>()
            .add(MealsRequested(category: CategoryType.allMeals));
        return Future.value(true);
      },
      child: SafeArea(
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            if (state is ThemeLoaded) {
              return Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: state.gradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: BlocBuilder<MealsBloc, MealsState>(
                      builder: (context, state) {
                        if (state is MealsLoading) {
                          return const Center(
                            child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 25,
                            ),
                          );
                        }
                        if (state is UserFavoriteMealsIdLoaded) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.read<MealsBloc>().add(
                                          MealsRequested(
                                              category: CategoryType.allMeals));
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: isAuthor
                                          ? const EdgeInsets.fromLTRB(
                                              8, 8, 8, 8)
                                          : const EdgeInsets.fromLTRB(
                                              8, 8, 56, 8),
                                      child: Align(
                                        child: Text(
                                          mealModel.name,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 22,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isAuthor)
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditMealScreen(
                                              mealModel: mealModel,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    )
                                  else
                                    const SizedBox.shrink(),
                                ],
                              ),
                              Expanded(
                                child: NestedScrollView(
                                  headerSliverBuilder:
                                      (context, innerBoxIsScrolled) {
                                    return [
                                      SliverAppBar(
                                        backgroundColor: Colors.transparent,
                                        expandedHeight:
                                            MediaQuery.of(context).size.height *
                                                0.4,
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
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
                                          itemCount:
                                              mealModel.ingredients.length,
                                        ),
                                        Center(
                                          child: Text(
                                            'Description',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
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
                                          itemCount:
                                              mealModel.description.length,
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
                    )),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
