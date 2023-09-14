import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/screens/meal_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.mealModel,
  });

  final MealModel mealModel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        child: Hero(
          tag: mealModel.id,
          child: GridTile(
            header: context
                    .read<MealsBloc>()
                    .checkIfAuthor(authorId: mealModel.authorId)
                ? Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.secondaryContainer,
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
              ),
            ),
          );
        },
      ),
    );
  }
}
