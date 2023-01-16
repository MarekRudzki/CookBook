import 'dart:convert';

import 'package:cookbook/src/features/account/screens/account_screen/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../services/firebase/firestore.dart';
import '../../../../services/firebase/storage.dart';
import '../../../../domain/models/meal_model.dart';
import '../../../../services/firebase/auth.dart';
import '../../../../services/hive_services.dart';
import '../../../../core/theme_provider.dart';
import '../../../account/account_provider.dart';
import '../../../common_widgets/error_handling.dart';
import '../../../main_screen.dart';
import '../../meals_provider.dart';
import '../add_meal_screen/widgets/meal_characteristics.dart';
import '../add_meal_screen/widgets/recipe_info_button.dart';
import '../add_meal_screen/widgets/meal_photo_picker.dart';
import '../add_meal_screen/widgets/meal_text_field.dart';

class EditMealScreen extends StatefulWidget {
  const EditMealScreen({
    super.key,
    required this.mealModel,
  });

  final MealModel mealModel;

  @override
  State<EditMealScreen> createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  late final TextEditingController _mealNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _imageUrlController;

  final ThemeProvider _themeProvider = ThemeProvider();
  final ErrorHandling _errorHandling = ErrorHandling();
  final MealsProvider _mealsProvider = MealsProvider();
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
    required String currentMealId,
  }) async {
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
        .updateImage(
      mealId: mealId,
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
      imageUrl = await _storage.getUrl(mealId: mealId);
    }

    final String username = await setUsername();

    await _firestore
        .updateMeal(
      mealId: currentMealId,
      mealName: mealNameTec.text,
      ingredientsList: ingredientsList,
      descriptionList: descriptionList,
      complexity: getComplexity(),
      isPublic: mealsProvider.isPublic,
      authorId: _auth.uid!,
      authorName: username,
      imageUrl: imageUrl,
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
        _ingredientsController.clear();
        _descriptionController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        _errorHandling.showInfoSnackbar(
          context,
          'Recipe updated successfully',
          Colors.green,
        );
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> deleteMeal({
    required String mealId,
    required String authorId,
    required String imageUrl,
  }) async {
    _errorHandling.toggleMealLoadingSpinner(context);
    await _mealsProvider.deleteMeal(
      mealId: mealId,
      authorId: authorId,
      imageUrl: imageUrl,
    );
    _errorHandling.toggleMealLoadingSpinner(context);
    FocusManager.instance.primaryFocus?.unfocus();
    _mealsProvider.imageUrl = '';
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
    _errorHandling.showInfoSnackbar(
      context,
      'Recipe deleted successfully',
      Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    int setComplexityOnce = 1;
    int setPublicOnce = 1;
    int setPhotoOnce = 1;

    void setComplexity(MealsProvider mealsProvider) {
      if (setComplexityOnce == 1) {
        if (widget.mealModel.complexity == 'Easy') {
          mealsProvider.complexity = Complexity.easy;
          setComplexityOnce++;
        } else if (widget.mealModel.complexity == 'Medium') {
          mealsProvider.complexity = Complexity.medium;
          setComplexityOnce++;
        } else {
          mealsProvider.complexity = Complexity.hard;
          setComplexityOnce++;
        }
      }
    }

    void setPublic(MealsProvider mealsProvider) {
      if (setPublicOnce == 1) {
        if (widget.mealModel.isPublic) {
          mealsProvider.isPublic = true;
          setPublicOnce++;
        } else {
          mealsProvider.isPublic = false;
          setPublicOnce++;
        }
      }
    }

    void setPhoto(MealsProvider mealsProvider) {
      if (setPhotoOnce == 1) {
        mealsProvider.selectedPhotoType = PhotoType.url;
        mealsProvider.imageUrl = widget.mealModel.imageUrl;
        setPhotoOnce++;
      } else {
        mealsProvider.selectedPhotoType = mealsProvider.selectedPhotoType;
      }
    }

    String ingredients() {
      final List<String> ingredinetsList = [];
      for (final ingredient in widget.mealModel.ingredients) {
        ingredinetsList.add(ingredient as String);
      }
      final String ingredients = ingredinetsList.join('\n');
      return ingredients;
    }

    String description() {
      final List<String> descriptionList = [];
      for (final description in widget.mealModel.description) {
        final String descriptionConverted = description.toString().substring(3);
        descriptionList.add(descriptionConverted);
      }
      final String description = descriptionList.join('\n');
      return description;
    }

    return SafeArea(
      child: Scaffold(
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
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Provider.of<MealsProvider>(context, listen: false)
                              .selectedPhotoType = null;
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      Text(
                        'Edit recipe',
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontSize: 25,
                            ),
                      ),
                      const RecipeInfoButton()
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MealTextField(
                    controller: _mealNameController
                      ..text = widget.mealModel.name,
                    labelText: 'Meal name',
                    hintText:
                        _mealNameController.text.isEmpty ? '' : 'Meal name',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MealTextField(
                    controller: _ingredientsController..text = ingredients(),
                    labelText: 'Ingredients',
                    hintText: _ingredientsController.text.isEmpty
                        ? ''
                        : 'Ingredients',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MealTextField(
                    controller: _descriptionController..text = description(),
                    labelText: 'Description',
                    hintText: _descriptionController.text.isEmpty
                        ? ''
                        : 'Description',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<MealsProvider>(
                    builder: (context, mealsProvider, _) {
                      setComplexity(mealsProvider);
                      setPublic(mealsProvider);
                      return MealCharacteristics(
                        mealsProvider: mealsProvider,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<MealsProvider>(
                    builder: (context, mealsProvider, _) {
                      setPhoto(mealsProvider);
                      return MealPhotoPicker(
                        mealsProvider: mealsProvider,
                        imageUrlController: _imageUrlController,
                      );
                    },
                  ),
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
                          if (_imageUrlController.text.isEmpty) {
                            _imageUrlController.text =
                                widget.mealModel.imageUrl;
                          }
                          await saveMeal(
                            currentMealId: widget.mealModel.id,
                            mealNameTec: _mealNameController,
                            ingredientsTec: _ingredientsController,
                            descriptionTec: _descriptionController,
                            mealsProvider: mealsProvider,
                          );
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: MaterialButton(
                      color: Theme.of(context).errorColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete_forever),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Delete recipe'),
                        ],
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: 'Are your sure?',
                              content: 'Do you want to delete this recipe?',
                              onConfirmed: () async {
                                await deleteMeal(
                                  mealId: widget.mealModel.id,
                                  authorId: widget.mealModel.authorId,
                                  imageUrl: widget.mealModel.imageUrl,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
