import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../../services/firebase/firestore.dart';
import '../../../../core/internet_not_connected.dart';
import '../../../../domain/models/meal_model.dart';
import '../../../../services/firebase/auth.dart';
import '../../../../services/hive_services.dart';
import '../../../../core/theme_provider.dart';
import '../../../common_widgets/error_handling.dart';
import '../../../account/account_provider.dart';
import '../../meals_provider.dart';
import 'widgets/meal_characteristics.dart';
import 'widgets/recipe_info_button.dart';
import 'widgets/meal_photo_picker.dart';
import 'widgets/meal_text_field.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _mealNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _themeProvider = ThemeProvider();

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
    int setMealOnce = 1;

    void resetFields(MealsProvider mealsProvider) {
      if (setMealOnce == 1) {
        mealsProvider.complexity = Complexity.easy;
        mealsProvider.isPublic = false;
        mealsProvider.imageUrl = '';
        mealsProvider.imageFile = null;
        mealsProvider.selectedPhotoType = null;
        setMealOnce++;
      }
    }

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
        child: Column(
          children: [
            Visibility(
              visible: Provider.of<InternetConnectionStatus>(context) ==
                  InternetConnectionStatus.disconnected,
              child: const InternetNotConnected(),
            ),
            Visibility(
              visible: Provider.of<InternetConnectionStatus>(context) ==
                  InternetConnectionStatus.connected,
              child: Expanded(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                    fontSize: 22,
                                  ),
                            ),
                            const RecipeInfoButton(),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MealTextField(
                          controller: _mealNameController,
                          labelText: 'Meal name',
                          hintText: _mealNameController.text.isEmpty
                              ? ''
                              : 'Meal name',
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MealTextField(
                          controller: _ingredientsController,
                          labelText: 'Ingredients',
                          hintText: _ingredientsController.text.isEmpty
                              ? ''
                              : 'Ingredients',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MealTextField(
                          controller: _descriptionController,
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
                            resetFields(mealsProvider);
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
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Save recipe',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                await mealsProvider.saveMeal(
                                  context: context,
                                  mealNameTec: _mealNameController,
                                  ingredientsTec: _ingredientsController,
                                  descriptionTec: _descriptionController,
                                  imageUrlTec: _imageUrlController,
                                  mounted: mounted,
                                  accountProvider: AccountProvider(
                                    Firestore(),
                                    HiveServices(),
                                    Auth(),
                                    ErrorHandling(),
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
