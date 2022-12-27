import 'package:cookbook/src/core/theme_provider.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = ThemeProvider();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _themeProvider.getGradient(),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Center(
              child: Text(
                'Add Screen',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('test here')),
          ],
        ),
      ),
    );
  }
}
