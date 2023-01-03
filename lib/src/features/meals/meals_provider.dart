import 'dart:io';

import 'package:cookbook/src/services/firebase/firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/models/meal_model.dart';

enum PhotoType { camera, gallery, url }

enum CategoryType { myMeals, allMeals, favorites }

class MealsProvider with ChangeNotifier {
  final Firestore _firestore = Firestore();
  // Meals info
  Complexity complexity = Complexity.easy;
  PhotoType? selectedPhotoType;
  bool isFavorite = false;
  bool isLoading = false;
  bool isPublic = false;
  File? imageFile;
  // MealsToggleButton
  CategoryType selectedCategory = CategoryType.allMeals;
  // Other
  String errorMessage = '';

  void setMealsCategory(CategoryType category) {
    selectedCategory = category;
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

  void resetFields() {
    selectedPhotoType = null;
    complexity = Complexity.easy;
    isPublic = false;
    isFavorite = false;
    notifyListeners();
  }

  void setImage(File image) {
    imageFile = image;
    notifyListeners();
  }

  Future<List<MealModel>> getUserMeals() async {
    final List<MealModel> allMeals = await _firestore.getUserMeals();
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
    final List<MealModel> allMeals = await _firestore.getUserMeals();
    final List<MealModel> publicMeals = [];

    for (final meal in allMeals) {
      if (meal.isPublic) {
        publicMeals.add(meal);
      }
    }
    return publicMeals;
  }

  //// Error handling
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
