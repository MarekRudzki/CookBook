import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../meals_provider.dart';

class MealsToggleButton extends StatelessWidget {
  const MealsToggleButton({
    super.key,
  });
  final double height = 40.0;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.9;
    return Consumer<MealsProvider>(
      builder: (context, mealsProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    alignment:
                        mealsProvider.selectedCategory == CategoryType.myMeals
                            ? Alignment.centerLeft
                            : mealsProvider.selectedCategory ==
                                    CategoryType.allMeals
                                ? Alignment.center
                                : Alignment.centerRight,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: width * 0.33,
                      height: height,
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
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
                            color: mealsProvider.selectedCategory ==
                                    CategoryType.myMeals
                                ? Colors.white
                                : Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      await mealsProvider.getUserMeals();
                      mealsProvider.setMealsCategory(CategoryType.myMeals);
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
                            color: mealsProvider.selectedCategory ==
                                    CategoryType.allMeals
                                ? Colors.white
                                : Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      mealsProvider.setMealsCategory(CategoryType.allMeals);
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
                            color: mealsProvider.selectedCategory ==
                                    CategoryType.favorites
                                ? Colors.white
                                : Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      mealsProvider.setMealsCategory(CategoryType.favorites);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
