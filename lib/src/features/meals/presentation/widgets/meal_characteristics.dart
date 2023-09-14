import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealCharacteristics extends StatelessWidget {
  const MealCharacteristics({super.key});

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return BlocBuilder<MealsBloc, MealsState>(
      builder: (context, state) {
        if (state is MealsInitial) {
          final Complexity complexity = state.complexity;
          final bool isPublic = state.isPublic;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Complexity',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      if (themeState is ThemeLoaded) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: themeState.isDarkTheme ? 0 : 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeState.isDarkTheme
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: [
                                Radio(
                                  value: Complexity.easy,
                                  groupValue: complexity,
                                  onChanged: (Complexity? complexity) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    context.read<MealsBloc>().add(
                                        MealCharacteristicsChanged(
                                            complexity: complexity!,
                                            isPublic: isPublic));
                                  },
                                  activeColor: Colors.green,
                                ),
                                Radio(
                                  value: Complexity.medium,
                                  groupValue: complexity,
                                  onChanged: (Complexity? complexity) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    context.read<MealsBloc>().add(
                                        MealCharacteristicsChanged(
                                            complexity: complexity!,
                                            isPublic: isPublic));
                                  },
                                  activeColor: Colors.orange,
                                ),
                                Radio(
                                  value: Complexity.hard,
                                  groupValue: complexity,
                                  onChanged: (Complexity? complexity) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    context.read<MealsBloc>().add(
                                        MealCharacteristicsChanged(
                                            complexity: complexity!,
                                            isPublic: isPublic));
                                  },
                                  activeColor: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    'Public',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Switch(
                    activeColor: Colors.amber,
                    value: isPublic,
                    onChanged: (bool switchPublic) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.read<MealsBloc>().add(MealCharacteristicsChanged(
                          complexity: complexity, isPublic: switchPublic));
                    },
                  )
                ],
              ),
            ],
          );
        } else
          return const SizedBox.shrink();
      },
    );
  }
}
