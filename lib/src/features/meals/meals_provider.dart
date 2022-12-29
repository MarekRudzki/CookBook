import 'dart:io';

import 'package:cookbook/src/domain/models/meal_model.dart';
import 'package:flutter/cupertino.dart';

enum PhotoType { camera, gallery, url }

class MealsProvider with ChangeNotifier {
  //TODO for now its locally, use firestore
  bool isFavorite = false;
  bool isPublic = false;
  PhotoType? selectedPhotoType;
  File? imageFile;
  Complexity complexity = Complexity.simple;
  bool isLoading = false;

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

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
