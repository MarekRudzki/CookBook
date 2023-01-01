import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/src/features/meals/meals_provider.dart';
import 'package:cookbook/src/features/meals/widgets/meal_item.dart';
import 'package:cookbook/src/services/firebase/firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/theme_provider.dart';
import '../../../services/hive_services.dart';
import '../../account/account_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HiveServices _hiveServices = HiveServices();
    final AccountProvider _accountProvider = AccountProvider();
    final Firestore _firestore = Firestore();
    final MealsProvider _mealsProvider = MealsProvider();
    String? username;

    // Get username from firestore in case, where user created account on
    // different device and there is no username in local storage//TODO check if this works
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
            child: Column(
              children: [
                StreamBuilder(
                    stream: _firestore.getSnapshots(),
                    builder: (context, snapshot) {
                      //snapshot.connectionState
                      //TODO add loading circle
                      return !snapshot.hasData
                          ? const SizedBox(
                              width: double.infinity,
                            )
                          : Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot product =
                                      snapshot.data!.docs[index];
                                  return MealItem(
                                    //TODO handle situation when photo url is no longer valid
                                    mealName: product['mealName'] as String,
                                    imageUrl: product['image_url'] as String,
                                  );
                                },
                                itemCount: snapshot.data!.docs.length,
                              ),
                            );
                    }),
              ],
            ),
            // Center(
            //   child: AnimatedContainer(
            //     duration: const Duration(seconds: 1),
            //     child: SizedBox(
            //       width: 250.0,
            //       child: DefaultTextStyle(
            //           style: const TextStyle(
            //             fontSize: 30.0,
            //             fontFamily: 'Bobbers',
            //           ),
            //           child: FutureBuilder(
            //             future: setUsername(),
            //             builder: (context, snapshot) {
            //               if (snapshot.hasData) {
            //                 return AnimatedTextKit(
            //                   isRepeatingAnimation: false,
            //                   animatedTexts: [
            //                     TyperAnimatedText(
            //                       'Hi $username how you doin?',
            //                     ),
            //                     TyperAnimatedText('Lets build something'),
            //                     TyperAnimatedText('And have fun!'),
            //                   ],
            //                 );
            //               }
            //               return const SizedBox.shrink();
            //             },
            //           )),
            //     ),
            //   ),
            // ),
          ),
        );
      },
    );
  }
}
