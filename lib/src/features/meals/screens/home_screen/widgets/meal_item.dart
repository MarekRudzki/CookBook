import 'package:flutter/material.dart';

import '../../../../../domain/models/meal_model.dart';
import '../../../meals_provider.dart';
import '../../meal_detail_screen/meal_details_screen.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.mealModel,
  });

  final MealModel mealModel;

  @override
  Widget build(BuildContext context) {
    final MealsProvider mealsProvider = MealsProvider();
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        child: Hero(
          tag: mealModel.id,
          child: GridTile(
            header: mealsProvider.checkIfAuthor(mealModel.authorId)
                ? Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              title: Center(
                child: Text(
                  mealModel.name,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            child: FadeInImage(
              placeholder: const AssetImage('assets/meal_loading.jpg'),
              image: NetworkImage(mealModel.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealDetailsScreen(
                mealModel: mealModel,
                mealsProvider: mealsProvider,
              ),
            ),
          );
        },
      ),
    );
  }
}
