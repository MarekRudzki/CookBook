import 'package:cookbook/src/features/meals/meals_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealsToggleButton extends StatelessWidget {
  final double height = 40.0;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.7;
    return Consumer<MealsProvider>(
      builder: (context, meals, _) {
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
                    alignment: meals.buttonIsMyMeals
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: width * 0.5,
                      height: height,
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: width * 0.5,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          'My meals',
                          style: TextStyle(
                            color: meals.buttonIsMyMeals
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      meals.toggleButtonStatus();
                    },
                  ),
                  GestureDetector(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: width * 0.5,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          'Signin',
                          style: TextStyle(
                            color: meals.buttonIsMyMeals
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      meals.toggleButtonStatus();
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
