import 'package:equatable/equatable.dart';

class MealModel extends Equatable {
  final String id;
  final String name;
  final List<dynamic> description;
  final List<dynamic> ingredients;
  final String imageUrl;
  final String mealAuthor;
  final String authorId;
  final bool isPublic;
  final String complexity;

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

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        ingredients,
        imageUrl,
        mealAuthor,
        authorId,
        isPublic,
        complexity,
      ];
}
