import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/models/meal_model.dart';

enum PhotoType { camera, gallery, url }

class MealsProvider with ChangeNotifier {
  // Meals info
  Complexity complexity = Complexity.easy;
  PhotoType? selectedPhotoType;
  bool isFavorite = false;
  bool isLoading = false;
  bool isPublic = false;
  File? imageFile;
  // MealsToggleButton
  bool buttonIsMyMeals = true;
  // Other
  String errorMessage = '';

  void toggleButtonStatus() {
    buttonIsMyMeals = !buttonIsMyMeals;
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
