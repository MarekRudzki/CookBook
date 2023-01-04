enum Complexity {
  easy,
  medium,
  hard,
}

class MealModel {
  MealModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
    required this.mealAuthor,
    required this.authorId,
    required this.isPublic,
    required this.complexity,
  });
  final String id;
  final String name;
  final List<dynamic> description;
  final List<dynamic> ingredients;
  final String imageUrl;
  final String mealAuthor;
  final String authorId;
  final bool isPublic;
  final String complexity;
}
