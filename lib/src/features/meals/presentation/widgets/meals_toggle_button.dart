import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsToggleButton extends StatelessWidget {
  const MealsToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.9;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Container(
          width: width,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: BlocBuilder<MealsBloc, MealsState>(
            builder: (context, state) {
              if (state is MealsLoaded) {
                return Stack(
                  children: [
                    AnimatedAlign(
                      alignment: state.category == CategoryType.myMeals
                          ? Alignment.centerLeft
                          : state.category == CategoryType.allMeals
                              ? Alignment.center
                              : Alignment.centerRight,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: width * 0.33,
                        height: 35,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).highlightColor.withOpacity(0.6),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: width * 0.33,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'My meals',
                            style: TextStyle(
                              fontSize: 15,
                              color: state.category == CategoryType.myMeals
                                  ? Colors.white
                                  : Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        context.read<MealsBloc>().add(
                            MealsRequested(category: CategoryType.myMeals));
                      },
                    ),
                    GestureDetector(
                      child: Align(
                        child: Container(
                          width: width * 0.33,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'All meals',
                            style: TextStyle(
                              fontSize: 15,
                              color: state.category == CategoryType.allMeals
                                  ? Colors.white
                                  : Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        context.read<MealsBloc>().add(
                            MealsRequested(category: CategoryType.allMeals));
                      },
                    ),
                    GestureDetector(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: width * 0.33,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'Favorites',
                            style: TextStyle(
                              fontSize: 15,
                              color: state.category == CategoryType.favorites
                                  ? Colors.white
                                  : Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        context.read<MealsBloc>().add(
                            MealsRequested(category: CategoryType.favorites));
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
