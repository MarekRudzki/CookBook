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
  final String description;

  final String ingredients;
  final String imageUrl;
  final String mealAuthor;
  final String isPublic;
  final Complexity complexity;
}
