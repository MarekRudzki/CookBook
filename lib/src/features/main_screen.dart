import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import '../core/constants.dart';
import 'account/screens/account_screen.dart';
import 'meals/screens/add_item_screen.dart';
import 'meals/screens/favorites_screen.dart';
import 'meals/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  PageController pageController = PageController();

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
      backgroundColor: kLighterBlue,
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
          body: SizedBox.expand(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              children: const [
                HomeScreen(),
                AddItemScreen(),
                FavoritesScreen(),
                AccountScreen(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavyBar(
            backgroundColor: kLighterBlue,
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Home'),
                activeColor: Colors.amber,
                inactiveColor: Colors.grey,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.add),
                title: const Text('Add'),
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.favorite),
                title: const Text('Favourites'),
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.person),
                title: const Text('Account'),
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
          ),
        ),
      ),
    );
  }
}
