import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../domain/models/meal_model.dart';
import '../../../../core/theme_provider.dart';
import '../../meals_provider.dart';
import 'widgets/details_meal_characteristics.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.mealModel,
  });

  final MealModel mealModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeProvider.getGradient(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: FutureBuilder(
                future: Provider.of<MealsProvider>(context, listen: false)
                    .getFavoritesMealsId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 56, 8),
                                child: Align(
                                  child: Text(
                                    mealModel.name,
                                    softWrap: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                          fontSize: 22,
                                        ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                backgroundColor: Colors.transparent,
                                expandedHeight:
                                    MediaQuery.of(context).size.height * 0.4,
                                leading: const SizedBox.shrink(),
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Hero(
                                    tag: mealModel.id,
                                    child: Image.network(
                                      fit: BoxFit.cover,
                                      mealModel.imageUrl,
                                    ),
                                  ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    DetailsMealCharacteristics(
                                      mealModel: mealModel,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 25),
                                      child: Divider(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
