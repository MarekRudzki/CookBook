import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/models/meal_model.dart';
import '../../services/firebase/firestore.dart';

enum PhotoType { camera, gallery, url }

class MealsProvider with ChangeNotifier {
  final Firestore _firestore = Firestore();
  //TODO for now its locally, use firestore
  bool isFavorite = false;
  bool isPublic = false;
  PhotoType? selectedPhotoType;
  File? imageFile;
  Complexity complexity = Complexity.easy;
  bool isLoading = false;
  String errorMessage = '';

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
