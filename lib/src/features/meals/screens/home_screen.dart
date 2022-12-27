import 'package:cookbook/src/core/theme_provider.dart';
import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../../account/account_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool> _setInterval() async {
      await Future.delayed(
        const Duration(
          milliseconds: 900,
        ),
      );
      return true;
    }

    final String username =
        context.select((AccountProvider provider) => provider.username);
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.getGradient(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: SizedBox(
                  width: 250.0,
                  child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Bobbers',
                      ),
                      child: FutureBuilder(
                        future: _setInterval(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TyperAnimatedText(
                                  'Hi $username how you doin?',
                                ),
                                TyperAnimatedText('Lets build something'),
                                TyperAnimatedText('And have fun!'),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      )),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
