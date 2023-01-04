import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/firebase/firestore.dart';
import '../../domain/models/meal_model.dart';
import '../../services/firebase/auth.dart';

enum PhotoType { camera, gallery, url }

enum CategoryType { myMeals, allMeals, favorites }

class MealsProvider with ChangeNotifier {
  final Firestore _firestore = Firestore();
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

  String getAuthorId() {
    return _auth.uid!;
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
    //  print(favoritesId);
  }

  Future<List<String>> getFavoritesMealsId() async {
    final List<String> mealsFavoritesId =
        await _firestore.getUserFavoriteMealsId();
    favoritesId = mealsFavoritesId;
    // print(favoritesId);
    notifyListeners();
    return mealsFavoritesId;
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
