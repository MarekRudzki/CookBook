enum Complexity {
  easy,
  medium,
  hard,
}

class MealModel {
  MealModel(
    this.id,
    this.name,
    this.description,
    this.ingredients,
    this.imageUrl,
    this.mealAuthor,
    this.isPublic,
    this.complexity,
  );
  final String id;
  final String name;
  final List<dynamic> description;

  final List<dynamic> ingredients;
  final String imageUrl;
  final String mealAuthor;
  final bool isPublic;
  final String complexity;
}
