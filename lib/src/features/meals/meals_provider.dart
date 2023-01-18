import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:nanoid/nanoid.dart';

import '../../services/firebase/firestore.dart';
import '../../services/firebase/storage.dart';
import '../../domain/models/meal_model.dart';
import '../../services/firebase/auth.dart';
import '../common_widgets/error_handling.dart';
import '../account/account_provider.dart';
import 'screens/meal_detail_screen/meal_details_screen.dart';

enum PhotoType { camera, gallery, url }

enum CategoryType { myMeals, allMeals, favorites }

class MealsProvider with ChangeNotifier {
  final ErrorHandling _errorHandling = ErrorHandling();
  final Firestore _firestore = Firestore();
  final Storage _storage = Storage();
  final Auth _auth = Auth();

  List<String> favoritesId = [];
  Complexity complexity = Complexity.easy;
  PhotoType? selectedPhotoType;
  bool isPublic = false;
  String imageUrl = '';
  File? imageFile;
  bool deletePrivateRecipes = true;
  bool deleteAllRecipes = false;

  CategoryType selectedCategory = CategoryType.allMeals;

  String errorMessage = '';
  bool isLoading = false;

  ///
  ////// Meal author
  ///

  bool checkIfAuthor({required String authorId}) {
    if (_auth.uid == authorId) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateMealAuthor({required String newUsername}) async {
    await _firestore.updateMealAuthor(newUsername: newUsername);
  }

  ///
  ////// Meals characteristics
  ///

  void setMealsCategory({required CategoryType category}) {
    selectedCategory = category;
    notifyListeners();
  }

  void setComplexity({required Complexity selectedComplexity}) {
    complexity = selectedComplexity;
    notifyListeners();
  }

  void changePhotoType(PhotoType? photoType) {
    selectedPhotoType = photoType;
    notifyListeners();
  }

  void removeCurrentPhoto() {
    selectedPhotoType = null;
    notifyListeners();
  }

  void togglePublic({required bool switchPublic}) {
    isPublic = switchPublic;
    notifyListeners();
  }

  void setImage({required File image}) {
    imageFile = image;
    notifyListeners();
  }

  void resetFields() {
    selectedPhotoType = null;
    complexity = Complexity.easy;
    isPublic = false;
    notifyListeners();
  }

  ///
  ////// Get meals by categories
  ///

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

  ///
  ////// User favorites
  ///

  Future<void> toggleMealFavorite({required String mealId}) async {
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

  ///
  ////// Error handling
  ///

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void addErrorMessage({required String message}) {
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

  Future<void> validateUrl({
    required BuildContext context,
    required TextEditingController urlController,
  }) async {
    Future<bool> validateStatusAndType() async {
      http.Response res;

      try {
        res = await http.get(
          Uri.parse(urlController.text),
        );
      } catch (error) {
        return false;
      }
      if (res.statusCode != 200) return false;

      if (urlController.text.endsWith('.jpg') ||
          urlController.text.endsWith('.jpeg') ||
          urlController.text.endsWith('.png')) {
        return true;
      } else {
        return false;
      }
    }

    if (urlController.text.trim().isEmpty) {
      addErrorMessage(message: 'Field is empty');
      resetErrorMessage();
    } else {
      _errorHandling.toggleMealLoadingSpinner(context);
      await validateStatusAndType().then(
        (bool isValid) {
          if (!isValid) {
            _errorHandling.toggleMealLoadingSpinner(context);
            addErrorMessage(message: 'Provided URL is not valid');
            resetErrorMessage();
          } else {
            _errorHandling.toggleMealLoadingSpinner(context);
            imageUrl = urlController.text;
            changePhotoType(PhotoType.url);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
      );
    }
  }

  ///
  ////// Meal delete
  ///

  void setDeleteAll({required bool value}) {
    deleteAllRecipes = value;
    deletePrivateRecipes = !value;
    notifyListeners();
  }

  void setDeletePrivate({required bool value}) {
    deletePrivateRecipes = value;
    deleteAllRecipes = !value;
    notifyListeners();
  }

  Future<void> deleteMeals({
    required bool deleteAll,
    required List<MealModel> userMeals,
  }) async {
    final List<String> recipesIdToDelete = [];
    for (final meal in userMeals) {
      if (deleteAll) {
        recipesIdToDelete.add(meal.id);
        if (meal.imageUrl.contains('firebasestorage')) {
          await _storage.deleteImage(imageId: meal.id);
        }
        await _firestore.deleteMeal(
          mealId: meal.id,
          userId: meal.authorId,
        );
      } else {
        if (!meal.isPublic) {
          recipesIdToDelete.add(meal.id);
          if (meal.imageUrl.contains('firebasestorage')) {
            await _storage.deleteImage(imageId: meal.id);
          }
          await _firestore.deleteMeal(
            mealId: meal.id,
            userId: meal.authorId,
          );
        }
      }
    }
  }

  Future<void> deleteSingleMeal({
    required BuildContext context,
    required String mealId,
    required String authorId,
    required String mealImageUrl,
    required void Function() onSuccess,
    required bool mounted,
  }) async {
    _errorHandling.toggleMealLoadingSpinner(context);

    await _firestore.deleteMeal(mealId: mealId, userId: authorId);
    if (mealImageUrl.contains('firebasestorage')) {
      await _storage.deleteImage(imageId: mealId);
    }
    imageUrl = '';
    FocusManager.instance.primaryFocus?.unfocus();
    if (!mounted) return;
    _errorHandling.toggleMealLoadingSpinner(context);
    onSuccess();
    _errorHandling.showInfoSnackbar(
      context,
      'Recipe deleted successfully',
      Colors.green,
    );
  }

  ///
  ////// Save and update meal
  ///

  Future<void> saveMeal({
    required BuildContext context,
    required TextEditingController mealNameTec,
    required TextEditingController ingredientsTec,
    required TextEditingController descriptionTec,
    required TextEditingController imageUrlTec,
  }) async {
    final AccountProvider accountProvider = AccountProvider();
    final List<String> ingredientsList = [];
    final List<String> descriptionList = [];
    String imageUrl;
    final generatedUid = nanoid(10);

    const LineSplitter ls = LineSplitter();
    int descriptionCount = 1;

    if (mealNameTec.text.trim().isEmpty ||
        ingredientsTec.text.trim().isEmpty ||
        descriptionTec.text.trim().isEmpty) {
      _errorHandling.showInfoSnackbar(
        context,
        'Please fill in all fields',
      );
      return;
    }

    if (imageUrlTec.text.isEmpty && imageFile == null) {
      _errorHandling.showInfoSnackbar(
        context,
        'Please provide photo',
      );
      return;
    }

    String getComplexity() {
      if (complexity == Complexity.easy) {
        return 'Easy';
      } else if (complexity == Complexity.medium) {
        return 'Medium';
      } else {
        return 'Hard';
      }
    }

    final List<String> ingredients = ls.convert(ingredientsTec.text);
    for (final element in ingredients) {
      if (element.trim().isNotEmpty) {
        ingredientsList.add(element);
      }
    }

    final List<String> description = ls.convert(descriptionTec.text);
    for (var element in description) {
      if (element.trim().isNotEmpty) {
        element = '${descriptionCount}. $element';
        descriptionCount++;
        descriptionList.add(element);
      }
    }

    _errorHandling.toggleMealLoadingSpinner(context);

    await _storage
        .uploadImage(
      mealId: generatedUid,
      image: imageFile,
      selectedPhotoType: selectedPhotoType,
    )
        .then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleAccountLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          addErrorMessage(message: errorText);
          resetErrorMessage();
          return;
        }
      },
    );

    if (selectedPhotoType == PhotoType.url) {
      imageUrl = imageUrlTec.text;
    } else {
      imageUrl = await _storage.getUrl(mealId: generatedUid);
    }

    final String username = await accountProvider.getUsername();

    await _firestore
        .addMeal(
      mealId: generatedUid,
      mealName: mealNameTec.text,
      ingredientsList: ingredientsList,
      descriptionList: descriptionList,
      complexity: getComplexity(),
      isPublic: isPublic,
      authorId: _auth.uid!,
      authorName: username,
      imageUrl: imageUrl,
      generatedUid: generatedUid,
    )
        .then((errorText) {
      if (errorText.isNotEmpty) {
        FocusManager.instance.primaryFocus?.unfocus();
        _errorHandling.showInfoSnackbar(
          context,
          errorText,
        );
      } else {
        _errorHandling.toggleMealLoadingSpinner(context);
        resetFields();
        getUserMeals();
        mealNameTec.clear();
        ingredientsTec.clear();
        descriptionTec.clear();
        imageUrlTec.clear();

        FocusManager.instance.primaryFocus?.unfocus();
        _errorHandling.showInfoSnackbar(
          context,
          'Recipe added successfully',
          Colors.green,
        );
      }
    });
  }

  Future<void> updateMeal({
    required BuildContext context,
    required TextEditingController mealNameTec,
    required TextEditingController ingredientsTec,
    required TextEditingController descriptionTec,
    required TextEditingController imageUrlTec,
    required String currentMealId,
  }) async {
    final AccountProvider accountProvider = AccountProvider();
    final List<String> ingredientsList = [];
    final List<String> descriptionList = [];
    String imageUrl;
    final mealId = currentMealId;

    const LineSplitter ls = LineSplitter();
    int descriptionCount = 1;

    if (mealNameTec.text.trim().isEmpty ||
        ingredientsTec.text.trim().isEmpty ||
        descriptionTec.text.trim().isEmpty) {
      _errorHandling.showInfoSnackbar(
        context,
        'Please fill in all fields',
      );
      return;
    }

    if (imageUrlTec.text.isEmpty && imageFile == null) {
      _errorHandling.showInfoSnackbar(
        context,
        'Please provide photo',
      );
      return;
    }

    String getComplexity() {
      if (complexity == Complexity.easy) {
        return 'Easy';
      } else if (complexity == Complexity.medium) {
        return 'Medium';
      } else {
        return 'Hard';
      }
    }

    final List<String> ingredients = ls.convert(ingredientsTec.text);
    for (final element in ingredients) {
      if (element.trim().isNotEmpty) {
        ingredientsList.add(element);
      }
    }

    final List<String> description = ls.convert(descriptionTec.text);
    for (var element in description) {
      if (element.trim().isNotEmpty) {
        element = '${descriptionCount}. $element';
        descriptionCount++;
        descriptionList.add(element);
      }
    }

    _errorHandling.toggleMealLoadingSpinner(context);

    await _storage
        .updateImage(
      mealId: mealId,
      image: imageFile,
      selectedPhotoType: selectedPhotoType,
    )
        .then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleAccountLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          addErrorMessage(message: errorText);
          resetErrorMessage();
          return;
        }
      },
    );
    if (selectedPhotoType == PhotoType.url) {
      imageUrl = imageUrlTec.text;
    } else {
      imageUrl = await _storage.getUrl(mealId: mealId);
    }

    final String username = await accountProvider.getUsername();

    await _firestore
        .updateMeal(
      mealId: currentMealId,
      mealName: mealNameTec.text,
      ingredientsList: ingredientsList,
      descriptionList: descriptionList,
      complexity: getComplexity(),
      isPublic: isPublic,
      authorId: _auth.uid!,
      authorName: username,
      imageUrl: imageUrl,
    )
        .then(
      (errorText) {
        if (errorText.isNotEmpty) {
          FocusManager.instance.primaryFocus?.unfocus();
          _errorHandling.showInfoSnackbar(
            context,
            errorText,
          );
        } else {
          final mealModel = MealModel(
            id: currentMealId,
            name: mealNameTec.text,
            description: descriptionList,
            ingredients: ingredientsList,
            imageUrl: imageUrl,
            mealAuthor: username,
            authorId: _auth.uid!,
            isPublic: isPublic,
            complexity: getComplexity(),
          );

          _errorHandling.toggleMealLoadingSpinner(context);
          resetFields();
          mealNameTec.clear();
          ingredientsTec.clear();
          descriptionTec.clear();
          imageUrlTec.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          _errorHandling.showInfoSnackbar(
            context,
            'Recipe updated successfully',
            Colors.green,
          );
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MealDetailsScreen(
              mealModel: mealModel,
              mealsProvider: this,
            ),
          ));
        }
      },
    );
  }
}
