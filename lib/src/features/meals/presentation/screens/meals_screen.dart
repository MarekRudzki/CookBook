import 'dart:math';

import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meals_grid.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meals_toggle_button.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import 'package:cookbook/src/core/internet_not_connected.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<MealsBloc>()
        .add(MealsRequested(category: CategoryType.allMeals));
    context.read<AuthBloc>().add(UsernameRequested());
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

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            if (state is ThemeLoaded) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: state.gradient,
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
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                  child: BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      if (state is AuthLoading) {
                                        return const SpinKitThreeBounce(
                                          size: 25,
                                          color: Colors.white,
                                        );
                                      } else if (state is UsernameLoaded) {
                                        return AnimatedTextKit(
                                          isRepeatingAnimation: false,
                                          animatedTexts: [
                                            TyperAnimatedText(
                                              getRandomGreeting(state.username),
                                              speed: const Duration(
                                                milliseconds: 80,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  )),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Divider(
                                color: Colors.white,
                                height: 2,
                              ),
                            ),
                            const MealsToggleButton(),
                            BlocBuilder<MealsBloc, MealsState>(
                              builder: (context, state) {
                                if (state is MealsLoaded) {
                                  if (state.category == CategoryType.myMeals) {
                                    return MealsGrid(
                                      mealData: state.data!,
                                      textIfEmpty:
                                          'You don\'t have any own recipes, try adding them or use others users recipes!',
                                    );
                                  } else if (state.category ==
                                      CategoryType.allMeals) {
                                    return MealsGrid(
                                      mealData: state.data!,
                                    );
                                  } else {
                                    return MealsGrid(
                                      mealData: state.data!,
                                      textIfEmpty:
                                          'No favorites meals yet, try add some!',
                                    );
                                  }
                                } else {
                                  return const Expanded(
                                    child: SpinKitThreeBounce(
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
