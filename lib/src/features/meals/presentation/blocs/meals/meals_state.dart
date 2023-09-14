part of 'meals_bloc.dart';

class MealsState extends Equatable {
  const MealsState();

  @override
  List<Object> get props => [];
}

class MealsInitial extends MealsState {
  final bool isPublic;
  final Complexity complexity;

  MealsInitial({
    this.isPublic = false,
    this.complexity = Complexity.easy,
  });

  MealsInitial copyWith({
    bool? isPublic,
    Complexity? complexity,
  }) {
    return MealsInitial(
      isPublic: isPublic ?? this.isPublic,
      complexity: complexity ?? this.complexity,
    );
  }

  @override
  List<Object> get props => [
        isPublic,
        complexity,
      ];
}

class MealsLoading extends MealsState {}

class MealsError extends MealsState {
  final String errorMessage;

  MealsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class MealsLoaded extends MealsState {
  final CategoryType category;
  final List<MealModel>? data;

  MealsLoaded({
    required this.category,
    this.data = const [],
  });

  @override
  List<Object> get props => [category];
}

class UserFavoriteMealsIdLoaded extends MealsState {
  final List<String> mealsId;

  UserFavoriteMealsIdLoaded({required this.mealsId});

  @override
  List<Object> get props => [mealsId];
}

class MealSaved extends MealsState {}

class MealDeleted extends MealsState {}
