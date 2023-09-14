import 'dart:io';

import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/meals/data/datasources/meals_firestore_remote_data_source.dart';
import 'package:cookbook/src/features/meals/data/datasources/meals_storage_remote_data_source.dart';
import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MealsRepository {
  final MealsFirestoreRemoteDataSource mealsFirestore;
  final MealsStorageRemoteDataSource mealsStorage;

  MealsRepository({
    required this.mealsFirestore,
    required this.mealsStorage,
  });

  // Storage

  Future<String> getUrl({
    required String mealId,
  }) async {
    final url = await mealsStorage.getUrl(mealId: mealId);
    return url;
  }

  Future<void> uploadImage({
    required String mealId,
    required File image,
    required PhotoType selectedPhotoType,
  }) async {
    await mealsStorage.uploadImage(
      mealId: mealId,
      image: image,
      selectedPhotoType: selectedPhotoType,
    );
  }

  Future<void> updateImage({
    required String mealId,
    required File image,
    required PhotoType selectedPhotoType,
  }) async {
    await mealsStorage.updateImage(
      mealId: mealId,
      image: image,
      selectedPhotoType: selectedPhotoType,
    );
  }

  // Firestore

  Future<void> addMeal({
    required String mealId,
    required String mealName,
    required List<String> ingredientsList,
    required List<String> descriptionList,
    required String complexity,
    required bool isPublic,
    required String authorId,
    required String authorName,
    required String imageUrl,
    required String generatedUid,
  }) async {
    await mealsFirestore.addMeal(
      mealId: mealId,
      mealName: mealName,
      ingredientsList: ingredientsList,
      descriptionList: descriptionList,
      complexity: complexity,
      isPublic: isPublic,
      authorId: authorId,
      authorName: authorName,
      imageUrl: imageUrl,
      generatedUid: generatedUid,
    );
  }

  Future<void> updateMeal({
    required String mealId,
    required String mealName,
    required List<String> ingredientsList,
    required List<String> descriptionList,
    required String complexity,
    required bool isPublic,
    required String authorId,
    required String authorName,
    required String imageUrl,
  }) async {
    await mealsFirestore.updateMeal(
      mealId: mealId,
      mealName: mealName,
      ingredientsList: ingredientsList,
      descriptionList: descriptionList,
      complexity: complexity,
      isPublic: isPublic,
      authorId: authorId,
      authorName: authorName,
      imageUrl: imageUrl,
    );
  }

  Future<List<MealModel>> getMeals() async {
    final snapshot = await mealsFirestore.getMeals();

    return snapshot
        .map(
          (doc) => MealModel(
            id: doc['mealId'] as String,
            name: doc['mealName'] as String,
            description: doc['description'] as List<dynamic>,
            ingredients: doc['ingredients'] as List<dynamic>,
            imageUrl: doc['image_url'] as String,
            mealAuthor: doc['authorName'] as String,
            authorId: doc['authorId'] as String,
            isPublic: doc['isPublic'] as bool,
            complexity: doc['complexity'] as String,
          ),
        )
        .toList();
  }

  Future<List<String>> getUserMealsId({
    required String uid,
  }) async {
    final mealsId = await mealsFirestore.getUserMealsId(
      uid: uid,
    );
    return mealsId;
  }

  Future<List<String>> getUserFavoriteMealsId({
    required String uid,
  }) async {
    final favoriteMealsId = await mealsFirestore.getUserFavoriteMealsId(
      uid: uid,
    );
    return favoriteMealsId;
  }

  Future<void> toggleMealFavorite({
    required String mealId,
    required String uid,
  }) async {
    await mealsFirestore.toggleMealFavorite(
      mealId: mealId,
      uid: uid,
    );
  }

  Future<void> deleteMeal({
    required String mealId,
    required String userId,
    required String imageUrl,
  }) async {
    await mealsFirestore.deleteMeal(
      mealId: mealId,
      userId: userId,
    );
    if (imageUrl.contains('firebasestorage')) {
      await mealsStorage.deleteImage(imageId: mealId);
    }
  }

  Future<List<MealModel>> getUserMeals({
    required String uid,
  }) async {
    final List<MealModel> allMeals = await getMeals();
    final List<String> userMealsId = await getUserMealsId(uid: uid);
    final List<MealModel> userMeals = [];

    for (final meal in allMeals) {
      if (userMealsId.contains(meal.id)) {
        userMeals.add(meal);
      }
    }
    return userMeals;
  }

  Future<void> deleteMeals({
    required bool deleteAll,
    required String uid,
  }) async {
    final List<MealModel> userMeals = await getUserMeals(uid: uid);

    for (final meal in userMeals) {
      if (deleteAll) {
        if (meal.imageUrl.contains('firebasestorage')) {
          await mealsStorage.deleteImage(imageId: meal.id);
        }
        await mealsFirestore.deleteMeal(mealId: meal.id, userId: meal.authorId);
      } else {
        if (!meal.isPublic) {
          if (meal.imageUrl.contains('firebasestorage')) {
            await mealsStorage.deleteImage(imageId: meal.id);
          }
          await mealsFirestore.deleteMeal(
              mealId: meal.id, userId: meal.authorId);
        }
      }
    }
  }

  Future<void> updateMealAuthor({
    required String newUsername,
    required String uid,
  }) async {
    await mealsFirestore.updateMealAuthor(
      newUsername: newUsername,
      uid: uid,
    );
  }
}
