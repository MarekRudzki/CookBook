import 'package:cookbook/src/core/theme_provider.dart';
import 'package:cookbook/src/services/hive_services.dart';
import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../../account/account_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HiveServices _hiveServices = HiveServices();
    final AccountProvider _accountProvider = AccountProvider();
    String? username;

    // Get username from firestore in case, where user created account on
    // different device and there is no username in local storage
    Future<bool> setUsername() async {
      if (_hiveServices.getUsername() != null) {
        username = _hiveServices.getUsername();
      } else {
        await _accountProvider.setUsername();
        username = _accountProvider.username;
      }
      return true;
    }

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
                        future: setUsername(),
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
