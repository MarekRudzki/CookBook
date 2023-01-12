import 'dart:convert';

import 'package:cookbook/src/features/account/account_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:nanoid/nanoid.dart';

import '../../../../services/firebase/firestore.dart';
import '../../../../services/firebase/storage.dart';
import '../../../../domain/models/meal_model.dart';
import '../../../../services/hive_services.dart';
import '../../../../services/firebase/auth.dart';
import '../../../../core/theme_provider.dart';
import '../../../common_widgets/error_handling.dart';
import '../../meals_provider.dart';
import 'widgets/add_meal_characteristics.dart';
import 'widgets/add_meal_photo_picker.dart';
import 'widgets/add_meal_text_field.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  late final TextEditingController _mealNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _imageUrlController;

  final ThemeProvider _themeProvider = ThemeProvider();
  final ErrorHandling _errorHandling = ErrorHandling();
  final Auth _auth = Auth();
  final HiveServices _hiveServices = HiveServices();
  final Firestore _firestore = Firestore();
  final Storage _storage = Storage();

  @override
  void initState() {
    super.initState();
    _mealNameController = TextEditingController();
    _ingredientsController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _ingredientsController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> saveMeal({
    required TextEditingController mealNameTec,
    required TextEditingController ingredientsTec,
    required TextEditingController descriptionTec,
    required MealsProvider mealsProvider,
  }) async {
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

    // Get username from firestore in case, where user created account on
    // different device and there is no username in local storage
    Future<String> setUsername() async {
      final AccountProvider accountProvider = AccountProvider();
      final String savedUsername = _hiveServices.getUsername();
      String currentUsername;
      if (savedUsername == 'no-username') {
        await accountProvider.setUsername();
        currentUsername = accountProvider.username;
      } else {
        currentUsername = _hiveServices.getUsername();
      }
      return currentUsername;
    }

    String getComplexity() {
      if (mealsProvider.complexity == Complexity.easy) {
        return 'Easy';
      } else if (mealsProvider.complexity == Complexity.medium) {
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
      image: mealsProvider.imageFile,
      mealsProvider: mealsProvider,
    )
        .then(
      (errorText) {
        if (errorText.isNotEmpty) {
          _errorHandling.toggleLoadingSpinner(context);
          FocusManager.instance.primaryFocus?.unfocus();
          mealsProvider.addErrorMessage(errorText);
          mealsProvider.resetErrorMessage();
          return;
        }
      },
    );

    if (mealsProvider.selectedPhotoType == PhotoType.url) {
      imageUrl = _imageUrlController.text;
    } else {
      imageUrl = await _storage.getUrl(mealId: generatedUid);
    }

    final String username = await setUsername();

    await _firestore
        .addMeal(
      mealId: generatedUid,
      mealName: mealNameTec.text,
      ingredientsList: ingredientsList,
      descriptionList: descriptionList,
      complexity: getComplexity(),
      isPublic: mealsProvider.isPublic,
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
        mealsProvider.resetFields();
        _mealNameController.clear();
        mealsProvider.getUserMeals();
        _ingredientsController.clear();
        _descriptionController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        _errorHandling.showInfoSnackbar(
          context,
          'Recipe added successfully',
          Colors.green,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _themeProvider.getGradient(),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 48,
                    ),
                    Text(
                      'Add new recipe',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 25,
                          ),
                    ),
                    IconButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Filling recipe fields',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'For beter formatting you should separate each element by new line in ingredients and description fields.',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Center(
                                      child: Container(
                                        height: 200,
                                        child: Image.asset(
                                            'assets/recipe_example.jpg'),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.5),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Okay',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                AddMealTextField(
                  controller: _mealNameController,
                  labelText: 'Meal name',
                  hintText: _mealNameController.text.isEmpty ? '' : 'Meal name',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                AddMealTextField(
                  controller: _ingredientsController,
                  labelText: 'Ingredients',
                  hintText:
                      _ingredientsController.text.isEmpty ? '' : 'Ingredients',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddMealTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText:
                      _descriptionController.text.isEmpty ? '' : 'Description',
                ),
                const SizedBox(
                  height: 10,
                ),
                const MealCharacteristics(),
                const SizedBox(
                  height: 10,
                ),
                PhotoPicker(imageUrlController: _imageUrlController),
                const SizedBox(
                  height: 10,
                ),
                Consumer<MealsProvider>(
                  builder: (context, mealsProvider, _) {
                    return MaterialButton(
                      color: Theme.of(context).highlightColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Save recipe'),
                        ],
                      ),
                      onPressed: () async {
                        saveMeal(
                          mealNameTec: _mealNameController,
                          ingredientsTec: _ingredientsController,
                          descriptionTec: _descriptionController,
                          mealsProvider: mealsProvider,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
