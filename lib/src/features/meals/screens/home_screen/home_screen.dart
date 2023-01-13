import 'dart:math';

import 'package:cookbook/src/core/internet_not_connected.dart';
import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../../services/hive_services.dart';
import '../../../../core/theme_provider.dart';
import '../../../account/account_provider.dart';
import '../../meals_provider.dart';
import 'widgets/meals_grid.dart';
import 'widgets/meals_toggle_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HiveServices _hiveServices = HiveServices();
    final AccountProvider _accountProvider = AccountProvider();

    // Get username from firestore in case, where user created account on
    // different device and there is no username in local storage
    Future<String> setUsername() async {
      final String savedUsername = _hiveServices.getUsername();
      String currentUsername;
      if (savedUsername == 'no-username') {
        await _accountProvider.setUsername();
        currentUsername = _accountProvider.username;
      } else {
        currentUsername = _hiveServices.getUsername();
      }
      return currentUsername;
    }

    String getRandomGreeting(String? username) {
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
                Visibility(
                  visible: Provider.of<InternetConnectionStatus>(context) ==
                      InternetConnectionStatus.disconnected,
                  child: const InternetNotConnected(),
                ),
                Visibility(
                  visible: Provider.of<InternetConnectionStatus>(context) ==
                      InternetConnectionStatus.connected,
                  child: Expanded(
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
                                        getRandomGreeting(snapshot.data),
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
                              return MealsGrid(
                                mealsProvider: mealsProvider,
                                future: mealsProvider.getUserMeals(),
                                textIfEmpty:
                                    'You don\'t have any own recipes, try adding them or use others users recipes!',
                              );
                            } else if (mealsProvider.selectedCategory ==
                                CategoryType.allMeals) {
                              return MealsGrid(
                                mealsProvider: mealsProvider,
                                future: mealsProvider.getPublicMeals(),
                              );
                            } else {
                              return MealsGrid(
                                mealsProvider: mealsProvider,
                                future: mealsProvider.getUserFavorites(),
                                textIfEmpty:
                                    'No favorites meals yet, try add some!',
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
