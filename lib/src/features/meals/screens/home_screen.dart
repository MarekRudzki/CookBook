import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cookbook/src/features/meals/meals_provider.dart';
import 'package:cookbook/src/features/meals/widgets/meal_item.dart';
import 'package:cookbook/src/features/meals/widgets/meals_toggle_button.dart';
import 'package:cookbook/src/services/firebase/firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/theme_provider.dart';
import '../../../services/hive_services.dart';
import '../../account/account_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HiveServices _hiveServices = HiveServices();
    final AccountProvider _accountProvider = AccountProvider();
    final Firestore _firestore = Firestore();
    String? username;
    // Get username from firestore in case, where user created account on
    // different device and there is no username in local storage//TODO check if this works
    Future<bool> setUsername() async {
      if (_hiveServices.getUsername() != null) {
        username = _hiveServices.getUsername();
      } else {
        await _accountProvider.setUsername();
        username = _accountProvider.username;
      }
      return true;
    }

    String getRandomGreeting(String username) {
      final rng = Random();
      final List<String> greetingsList = [
        'Let`s cook $username!',
        'Keep calm and cook on!',
        'Good food = good mood!',
        'What are we cooking today $username?',
        'When life gives you lemons, make lemonade!',
        '"No one is born a great cook, one learns by doing"',
        'Life is short, consume dessert!',
        'The secret ingredient is ALWAYS cheese!',
      ];
      final String greeting = greetingsList[rng.nextInt(greetingsList.length)];
      return greeting;
    }

    return Consumer<ThemeProvider>(
      builder: (context, theme, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.getGradient(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.headline1!,
                    child: FutureBuilder(
                      future: setUsername(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AnimatedTextKit(
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TyperAnimatedText(
                                getRandomGreeting(username!),
                                speed: const Duration(
                                  milliseconds: 80,
                                ),
                              ),
                            ],
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    color: Colors.grey,
                    height: 2,
                  ),
                ),
                const MealsToggleButton(),
                Consumer<MealsProvider>(
                  builder: (context, mealsProvider, _) {
                    if (mealsProvider.selectedCategory ==
                        CategoryType.myMeals) {
                      return MyMealsGrid(mealsProvider: mealsProvider);
                    } else if (mealsProvider.selectedCategory ==
                        CategoryType.allMeals) {
                      return AllMealsGrid(mealsProvider: mealsProvider);
                    } else {
                      return Container(
                        child: const Text('Favorites'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AllMealsGrid extends StatelessWidget {
  const AllMealsGrid({
    super.key,
    required this.mealsProvider,
  });

  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mealsProvider.getPublicMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
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
                  mealName: snapshot.data![index].name,
                  imageUrl: snapshot.data![index].imageUrl,
                );
              },
              itemCount: snapshot.data!.length,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class MyMealsGrid extends StatelessWidget {
  const MyMealsGrid({
    super.key,
    required this.mealsProvider,
  });

  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mealsProvider.getUserMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data!.isEmpty) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'You don\'t have any own recipes, try adding them or use others users recipes!',
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
                  mealName: snapshot.data![index].name,
                  imageUrl: snapshot.data![index].imageUrl,
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
