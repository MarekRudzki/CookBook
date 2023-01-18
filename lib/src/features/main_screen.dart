import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';

import '../core/theme_provider.dart';
import '../core/constants.dart';
import 'account/screens/account_screen/account_screen.dart';
import 'meals/screens/add_meal_screen/add_meal_screen.dart';
import 'meals/screens/home_screen/home_screen.dart';
import 'account/account_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AccountProvider>(context, listen: false).setUsername();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      backgroundColor: kDarkModeLighter,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          // ignore: avoid_bool_literals_in_conditional_expressions
          resizeToAvoidBottomInset: selectedIndex == 1 ? true : false,
          body: SizedBox.expand(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              children: [
                const HomeScreen(),
                const AddMealScreen(),
                const AccountScreen(),
              ],
            ),
          ),
          bottomNavigationBar: Consumer<ThemeProvider>(
            builder: (context, theme, _) {
              return BottomNavyBar(
                backgroundColor:
                    theme.isDark() ? kDarkModeLighter : kLightModeLighter,
                items: [
                  BottomNavyBarItem(
                    icon: const Icon(Icons.home),
                    title: Text(
                      'Home',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    activeColor: Theme.of(context).highlightColor,
                    inactiveColor:
                        theme.isDark() ? kLightModeLighter : kDarkModeDarker,
                  ),
                  BottomNavyBarItem(
                    icon: const Icon(Icons.add),
                    title: Text(
                      'Add',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    activeColor: Theme.of(context).highlightColor,
                    inactiveColor:
                        theme.isDark() ? kLightModeLighter : kDarkModeDarker,
                  ),
                  BottomNavyBarItem(
                    icon: const Icon(Icons.person),
                    title: Text(
                      'Account',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    activeColor: Theme.of(context).highlightColor,
                    inactiveColor:
                        theme.isDark() ? kLightModeLighter : kDarkModeDarker,
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
            },
          ),
        ),
      ),
    );
  }
}
