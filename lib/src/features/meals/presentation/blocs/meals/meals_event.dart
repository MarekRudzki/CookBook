part of 'meals_bloc.dart';

class MealsEvent extends Equatable {
  const MealsEvent();

  @override
  List<Object> get props => [];
}

class ToggleMealFavoritePressed extends MealsEvent {
  final String mealId;

  ToggleMealFavoritePressed({required this.mealId});

  @override
  List<Object> get props => [mealId];
}

class UserFavoriteMealsIdRequested extends MealsEvent {}

class AddMealPressed extends MealsEvent {
  final String mealName;
  final String ingredients;
  final String description;
  final String imageUrl;
  final PhotoType selectedPhotoType;
  final File? imageFile;
  final Complexity complexity;
  final bool isPublic;

  AddMealPressed({
    required this.mealName,
    required this.ingredients,
    required this.description,
    required this.imageUrl,
    required this.selectedPhotoType,
    this.imageFile,
    required this.complexity,
    required this.isPublic,
  });

  @override
  List<Object> get props => [
        mealName,
        ingredients,
        description,
        imageUrl,
        selectedPhotoType,
        complexity,
        isPublic,
      ];
}

class EditMealPressed extends MealsEvent {
  final String mealName;
  final String ingredients;
  final String description;
  final String imageUrl;
  final PhotoType selectedPhotoType;
  final File? imageFile;
  final Complexity complexity;
  final bool isPublic;
  final String mealId;
  final String mealAuthor;
  final String authorId;

  EditMealPressed({
    required this.mealName,
    required this.ingredients,
    required this.description,
    required this.imageUrl,
    required this.selectedPhotoType,
    this.imageFile,
    required this.complexity,
    required this.isPublic,
    required this.mealId,
    required this.mealAuthor,
    required this.authorId,
  });

  @override
  List<Object> get props => [
        mealName,
        ingredients,
        description,
        imageUrl,
        selectedPhotoType,
        complexity,
        isPublic,
        mealId,
        mealAuthor,
        authorId,
      ];
}

class MealCharacteristicsChanged extends MealsEvent {
  final Complexity complexity;
  final bool isPublic;

  MealCharacteristicsChanged({
    required this.complexity,
    required this.isPublic,
  });

  @override
  List<Object> get props => [complexity, isPublic];
}

class MealsRequested extends MealsEvent {
  final CategoryType category;

  MealsRequested({required this.category});

  @override
  List<Object> get props => [category];
}

class ResetInitialState extends MealsEvent {}

class DeleteMealPressed extends MealsEvent {
  final String mealId;
  final String userId;
  final String imageUrl;

  DeleteMealPressed(
      {required this.mealId, required this.userId, required this.imageUrl});

  @override
  List<Object> get props => [
        mealId,
        userId,
        imageUrl,
      ];
}
