import 'dart:io';

import 'package:cookbook/src/services/firebase/storage.dart';
import 'package:flutter/material.dart';

import '../../services/firebase/firestore.dart';
import '../../domain/models/meal_model.dart';
import '../../services/firebase/auth.dart';

enum PhotoType { camera, gallery, url }

enum CategoryType { myMeals, allMeals, favorites }

class MealsProvider with ChangeNotifier {
  final Firestore _firestore = Firestore();
  final Storage _storage = Storage();
  final Auth _auth = Auth();

  /// Meals
  List<String> favoritesId = [];
  Complexity complexity = Complexity.easy;
  PhotoType? selectedPhotoType;
  bool isFavorite = false;
  bool isPublic = false;
  File? imageFile;

  /// MealsToggleButton
  CategoryType selectedCategory = CategoryType.allMeals;

  /// Error handling
  String errorMessage = '';
  bool isLoading = false;

  bool checkIfAuthor(String authorId) {
    if (_auth.uid == authorId) {
      return true;
    } else {
      return false;
    }
  }

  /// Meals
  void setComplexity({required Complexity selectedComplexity}) {
    complexity = selectedComplexity;
    notifyListeners();
  }

  void changePhotoType(PhotoType photoType) {
    selectedPhotoType = photoType;
    notifyListeners();
  }

  void removeCurrentPhoto() {
    selectedPhotoType = null;
    notifyListeners();
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void togglePublic({required bool switchPublic}) {
    isPublic = switchPublic;
    notifyListeners();
  }

  void setImage(File image) {
    imageFile = image;
    notifyListeners();
  }

  void resetFields() {
    selectedPhotoType = null;
    complexity = Complexity.easy;
    isPublic = false;
    isFavorite = false;
    notifyListeners();
  }

  Future<List<MealModel>> getUserMeals() async {
    final List<MealModel> allMeals = await _firestore.getMeals();
    final List<String> userMealsId = await _firestore.getUserMealsId();

    final List<MealModel> userMeals = [];

    for (final meal in allMeals) {
      if (userMealsId.contains(meal.id)) {
        userMeals.add(meal);
      }
    }
    return userMeals;
  }

  Future<List<MealModel>> getPublicMeals() async {
    final List<MealModel> allMeals = await _firestore.getMeals();
    final List<MealModel> publicMeals = [];

    for (final meal in allMeals) {
      if (meal.isPublic) {
        publicMeals.add(meal);
      }
    }
    return publicMeals;
  }

  Future<List<MealModel>> getUserFavorites() async {
    final List<MealModel> allMeals = await _firestore.getMeals();
    final List<String> userFavoritesMealsId =
        await _firestore.getUserFavoriteMealsId();

    final List<MealModel> userMeals = [];

    for (final meal in allMeals) {
      if (userFavoritesMealsId.contains(meal.id)) {
        userMeals.add(meal);
      }
    }
    return userMeals;
  }

  Future<void> toggleMealFavorite(String mealId) async {
    await _firestore.toggleMealFavorite(mealId);
    final List<String> mealsFavoritesId =
        await _firestore.getUserFavoriteMealsId();
    favoritesId = mealsFavoritesId;
    notifyListeners();
  }

  Future<List<String>> getFavoritesMealsId() async {
    final List<String> mealsFavoritesId =
        await _firestore.getUserFavoriteMealsId();
    favoritesId = mealsFavoritesId;
    notifyListeners();
    return mealsFavoritesId;
  }

  Future<void> deleteMeals(
      {required bool deleteAll, required List<MealModel> userMeals}) async {
    final List<String> recipesIdToDelete = [];

    for (final meal in userMeals) {
      if (deleteAll) {
        recipesIdToDelete.add(meal.id);
        await _storage.deleteImage(imageId: meal.id);
        await _firestore.deleteMeal(
          mealId: meal.id,
          userId: meal.authorId,
        );
      } else {
        if (meal.isPublic) {
          recipesIdToDelete.add(meal.id);
          await _storage.deleteImage(imageId: meal.id);
          await _firestore.deleteMeal(
            mealId: meal.id,
            userId: meal.authorId,
          );
        }
      }
    }
  }

  /// MealsToggleButton
  void setMealsCategory(CategoryType category) {
    selectedCategory = category;
    notifyListeners();
  }

  /// Error handling
  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void addErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<void> resetErrorMessage() async {
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    errorMessage = '';
    notifyListeners();
  }
}
