import 'dart:convert';
import 'dart:io';

import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/domain/repositories/meals_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nanoid/nanoid.dart';

part 'meals_event.dart';
part 'meals_state.dart';

@injectable
class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final MealsRepository mealsRepository;
  final AuthRepository authRepository;

  MealsBloc(this.mealsRepository, this.authRepository) : super(MealsInitial()) {
    on<UserFavoriteMealsIdRequested>(_onUserFavoriteMealsIdRequested);
    on<ToggleMealFavoritePressed>(_onToggleMealFavoritePressed);
    on<MealCharacteristicsChanged>(_onMealCharacteristicsChanged);
    on<AddMealPressed>(_onAddMealPressed);
    on<EditMealPressed>(_onEditMealPressed);
    on<MealsRequested>(_onMealsRequested);
    on<ResetInitialState>(_onResetInitialState);
    on<DeleteMealPressed>(_onDeleteMealPressed);
  }

  Future<void> _onMealsRequested(
    MealsRequested event,
    Emitter<MealsState> emit,
  ) async {
    emit(MealsLoading());
    final String uid = authRepository.getUid();
    final allMeals = await mealsRepository.getMeals();
    if (event.category == CategoryType.myMeals) {
      final userMealsId = await mealsRepository.getUserMealsId(uid: uid);
      final List<MealModel> userMeals = [];

      for (final meal in allMeals) {
        if (userMealsId.contains(meal.id)) {
          userMeals.add(meal);
        }
      }
      emit(MealsLoaded(category: CategoryType.myMeals, data: userMeals));
    } else if (event.category == CategoryType.allMeals) {
      final List<MealModel> publicMeals = [];

      for (final meal in allMeals) {
        if (meal.isPublic) {
          publicMeals.add(meal);
        }
      }

      emit(MealsLoaded(category: CategoryType.allMeals, data: publicMeals));
    } else {
      final userFavoriteMealsId =
          await mealsRepository.getUserFavoriteMealsId(uid: uid);
      final List<MealModel> userFavorites = [];

      for (final meal in allMeals) {
        if (userFavoriteMealsId.contains(meal.id)) {
          userFavorites.add(meal);
        }
      }
      emit(MealsLoaded(category: CategoryType.favorites, data: userFavorites));
    }
  }

  bool checkIfAuthor({required String authorId}) {
    if (authRepository.getUid() == authorId) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _onUserFavoriteMealsIdRequested(
    UserFavoriteMealsIdRequested event,
    Emitter<MealsState> emit,
  ) async {
    emit(MealsLoading());
    final String uid = authRepository.getUid();
    final userFavoriteMealsId =
        await mealsRepository.getUserFavoriteMealsId(uid: uid);

    emit(UserFavoriteMealsIdLoaded(mealsId: userFavoriteMealsId));
  }

  Future<void> _onToggleMealFavoritePressed(
    ToggleMealFavoritePressed event,
    Emitter<MealsState> emit,
  ) async {
    final String uid = authRepository.getUid();

    await mealsRepository.toggleMealFavorite(mealId: event.mealId, uid: uid);

    final userFavoriteMealsId =
        await mealsRepository.getUserFavoriteMealsId(uid: uid);

    emit(UserFavoriteMealsIdLoaded(mealsId: userFavoriteMealsId));
  }

  void _onMealCharacteristicsChanged(
    MealCharacteristicsChanged event,
    Emitter<MealsState> emit,
  ) {
    emit(MealsInitial()
        .copyWith(complexity: event.complexity, isPublic: event.isPublic));
  }

  void _onResetInitialState(
    ResetInitialState event,
    Emitter<MealsState> emit,
  ) {
    emit(MealsInitial());
  }

  Future<void> _onAddMealPressed(
    AddMealPressed event,
    Emitter<MealsState> emit,
  ) async {
    final List<String> ingredientsList = [];
    final List<String> descriptionList = [];
    String imageUrl;
    final generatedUid = nanoid(10);

    const LineSplitter ls = LineSplitter();
    int descriptionCount = 1;

    if (event.mealName.isEmpty ||
        event.ingredients.isEmpty ||
        event.description.isEmpty) {
      emit(MealsError(errorMessage: 'Please fill in all fields'));
      emit(MealsInitial().copyWith(
        complexity: event.complexity,
        isPublic: event.isPublic,
      ));
      return;
    }

    String getComplexity() {
      if (event.complexity == Complexity.easy) {
        return 'Easy';
      } else if (event.complexity == Complexity.medium) {
        return 'Medium';
      } else {
        return 'Hard';
      }
    }

    final List<String> ingredients = ls.convert(event.ingredients);
    for (final element in ingredients) {
      if (element.trim().isNotEmpty) {
        ingredientsList.add(element);
      }
    }

    final List<String> description = ls.convert(event.description);
    for (var element in description) {
      if (element.trim().isNotEmpty) {
        element = '${descriptionCount}. $element';
        descriptionCount++;
        descriptionList.add(element);
      }
    }
    emit(MealsLoading());
    try {
      if (event.selectedPhotoType != PhotoType.url) {
        await mealsRepository.uploadImage(
          mealId: generatedUid,
          image: event.imageFile!,
          selectedPhotoType: event.selectedPhotoType,
        );
      }
      if (event.selectedPhotoType == PhotoType.url) {
        imageUrl = event.imageUrl;
      } else {
        imageUrl = await mealsRepository.getUrl(mealId: generatedUid);
      }

      final String username;
      final String usernameHive = authRepository.getUsernameHive();
      if (usernameHive == 'no-username') {
        final String usernameFirestore =
            await authRepository.getUsernameFirestore();
        username = usernameFirestore;
      } else {
        username = usernameHive;
      }

      await mealsRepository.addMeal(
        mealId: generatedUid,
        mealName: event.mealName,
        ingredientsList: ingredientsList,
        descriptionList: descriptionList,
        complexity: getComplexity(),
        isPublic: event.isPublic,
        authorId: authRepository.getUid(),
        authorName: username,
        imageUrl: imageUrl,
        generatedUid: generatedUid,
      );
    } catch (error) {
      emit(MealsError(
          errorMessage: error.toString().replaceFirst('Exception: ', '')));
      return;
    }
    emit(MealSaved());
    emit(MealsInitial());
  }

  Future<void> _onEditMealPressed(
    EditMealPressed event,
    Emitter<MealsState> emit,
  ) async {
    String imageUrl;
    final List<String> ingredientsList = [];
    final List<String> descriptionList = [];
    const LineSplitter ls = LineSplitter();
    int descriptionCount = 1;

    if (event.mealName.isEmpty ||
        event.ingredients.isEmpty ||
        event.description.isEmpty) {
      emit(MealsError(errorMessage: 'Please fill in all fields'));
      emit(MealsInitial().copyWith(
        complexity: event.complexity,
        isPublic: event.isPublic,
      ));
      return;
    }

    String getComplexity() {
      if (event.complexity == Complexity.easy) {
        return 'Easy';
      } else if (event.complexity == Complexity.medium) {
        return 'Medium';
      } else {
        return 'Hard';
      }
    }

    final List<String> ingredients = ls.convert(event.ingredients);
    for (final element in ingredients) {
      if (element.trim().isNotEmpty) {
        ingredientsList.add(element);
      }
    }

    final List<String> description = ls.convert(event.description);
    for (var element in description) {
      if (element.trim().isNotEmpty) {
        element = '${descriptionCount}. $element';
        descriptionCount++;
        descriptionList.add(element);
      }
    }
    emit(MealsLoading());
    try {
      if (event.selectedPhotoType != PhotoType.url) {
        await mealsRepository.updateImage(
          mealId: event.mealId,
          image: event.imageFile!,
          selectedPhotoType: event.selectedPhotoType,
        );
      }

      if (event.selectedPhotoType == PhotoType.url) {
        imageUrl = event.imageUrl;
      } else {
        imageUrl = await mealsRepository.getUrl(mealId: event.mealId);
      }

      await mealsRepository.updateMeal(
        mealId: event.mealId,
        mealName: event.mealName,
        ingredientsList: ingredientsList,
        descriptionList: descriptionList,
        complexity: getComplexity(),
        isPublic: event.isPublic,
        authorId: event.authorId,
        authorName: event.mealAuthor,
        imageUrl: imageUrl,
      );
    } catch (error) {
      emit(MealsError(
          errorMessage: error.toString().replaceFirst('Exception: ', '')));
      return;
    }
    emit(MealSaved());
    emit(MealsInitial());
  }

  Future<void> _onDeleteMealPressed(
    DeleteMealPressed event,
    Emitter<MealsState> emit,
  ) async {
    try {
      await mealsRepository.deleteMeal(
        mealId: event.mealId,
        userId: event.userId,
        imageUrl: event.imageUrl,
      );
      emit(MealDeleted());
      emit(MealsInitial());
    } catch (error) {
      emit(MealsError(
          errorMessage: error.toString().replaceFirst('Exception: ', '')));
      emit(MealsInitial());
      return;
    }
  }
}
