import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../services/firebase/firestore.dart';
import '../../../../services/firebase/storage.dart';
import '../../../../domain/models/meal_model.dart';
import '../../../../services/firebase/auth.dart';
import '../../../../services/hive_services.dart';
import '../../../../core/theme_provider.dart';
import '../../../account/screens/account_screen/widgets/custom_alert_dialog.dart';
import '../../../common_widgets/error_handling.dart';
import '../../../account/account_provider.dart';
import '../../../main_screen.dart';
import '../../meals_provider.dart';
import '../add_meal_screen/widgets/meal_characteristics.dart';
import '../add_meal_screen/widgets/recipe_info_button.dart';
import '../add_meal_screen/widgets/meal_photo_picker.dart';
import '../add_meal_screen/widgets/meal_text_field.dart';
import '../meal_detail_screen/meal_details_screen.dart';

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
  final _mealNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _themeProvider = ThemeProvider();
  final _mealsProvider = MealsProvider(
    Firestore(),
    Auth(),
    Storage(),
    ErrorHandling(),
  );

  @override
  void dispose() {
    _mealNameController.dispose();
    _ingredientsController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
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
                          size: 22,
                        ),
                      ),
                      Text(
                        'Edit recipe',
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontSize: 22,
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
                            const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Save recipe',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (_imageUrlController.text.isEmpty) {
                            _imageUrlController.text =
                                widget.mealModel.imageUrl;
                          }
                          await mealsProvider
                              .updateMeal(
                                context: context,
                                mealNameTec: _mealNameController,
                                ingredientsTec: _ingredientsController,
                                descriptionTec: _descriptionController,
                                imageUrlTec: _imageUrlController,
                                currentMealId: widget.mealModel.id,
                                accountProvider: AccountProvider(
                                  Firestore(),
                                  HiveServices(),
                                  Auth(),
                                  ErrorHandling(),
                                ),
                              )
                              .then((mealModel) => {
                                    if (mealModel.authorId.isNotEmpty)
                                      {
                                        Navigator.of(context).pop(),
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MealDetailsScreen(
                                              mealModel: mealModel,
                                              mealsProvider: mealsProvider,
                                            ),
                                          ),
                                        ),
                                      }
                                  });
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
                          const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Delete recipe',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: 'Are your sure?',
                              content: 'Do you want to delete this recipe?',
                              contentColor: Colors.blue.shade400,
                              onConfirmed: () async {
                                await _mealsProvider.deleteSingleMeal(
                                  context: context,
                                  mealId: widget.mealModel.id,
                                  authorId: widget.mealModel.authorId,
                                  mealImageUrl: widget.mealModel.imageUrl,
                                  mounted: mounted,
                                  onSuccess: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen(),
                                      ),
                                    );
                                  },
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
