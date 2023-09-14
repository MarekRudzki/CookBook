import 'package:cookbook/src/features/authentication/presentation/screens/account_screen.dart';
import 'package:cookbook/src/features/common_widgets/on_will_pop_alert_dialog.dart';
import 'package:cookbook/src/features/meals/presentation/screens/add_meal_screen.dart';
import 'package:cookbook/src/features/meals/presentation/screens/meals_screen.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cookbook/src/core/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool? exitResult = await showDialog(
          context: context,
          builder: (context) => const OnWillPopAlertDialog(),
        );
        return exitResult ?? false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: selectedIndex == 1,
          body: SizedBox.expand(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              children: [
                const MealsScreen(),
                const AddMealScreen(),
                const AccountScreen(),
              ],
            ),
          ),
          bottomNavigationBar: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              if (state is ThemeLoaded) {
                return BottomNavyBar(
                  backgroundColor:
                      state.isDarkTheme ? kDarkModeLighter : kLightModeLighter,
                  items: [
                    BottomNavyBarItem(
                      icon: const Icon(Icons.home),
                      title: Text(
                        'Home',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey.shade600,
                    ),
                    BottomNavyBarItem(
                      icon: const Icon(Icons.add),
                      title: Text(
                        'Add',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey.shade600,
                    ),
                    BottomNavyBarItem(
                      icon: const Icon(Icons.person),
                      title: Text(
                        'Account',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey.shade600,
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onItemSelected: (value) {
                    selectedIndex = value;
                    pageController.animateToPage(
                      value,
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      curve: Curves.easeIn,
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
