import 'package:flutter/material.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.mealName,
    required this.imageUrl,
  });

  final String mealName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          title: Center(
            child: Text(
              mealName,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        child: GestureDetector(
          child: Hero(
            tag: '1',
            child: FadeInImage(
              placeholder: const AssetImage('assets/meal_loading.jpg'),
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            //Navigator.push
          },
        ),
      ),
    );
  }
}
