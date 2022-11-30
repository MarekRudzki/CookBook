import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import '/constants.dart';
import '../account_screen.dart';
import '../add_screen.dart';
import '../favourites_screen.dart';
import '../home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: PageView(
            controller: pageController,
            onPageChanged: ((value) {
              setState(() {
                selectedIndex = value;
              });
            }),
            children: const [
              HomeScreen(),
              AddScreen(),
              FavouritesScreen(),
              AccountScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: darkThemeGradientFirst,
          items: [
            BottomNavyBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Home'),
                activeColor: Colors.amber,
                inactiveColor: Colors.grey),
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
    );
  }
}
