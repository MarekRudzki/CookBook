import 'dart:io';

import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/common_widgets/custom_snackbar.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/photo_picker/photo_picker_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meal_characteristics.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meal_photo_picker.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meal_text_field.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/recipe_info_button.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import 'package:cookbook/src/core/internet_not_connected.dart';

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

  @override
  void dispose() {
    _mealNameController.dispose();
    _ingredientsController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void clearControllers() {
    _mealNameController.clear();
    _ingredientsController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MealsBloc>().add(ResetInitialState());
    return Scaffold(
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          if (themeState is ThemeLoaded) {
            return Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: themeState.gradient,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: BlocListener<MealsBloc, MealsState>(
                listener: (context, mealsState) {
                  if (mealsState is MealsError) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(CustomSnackbar.showSnackBar(
                      message: mealsState.errorMessage,
                    ));
                  } else if (mealsState is MealSaved) {
                    clearControllers();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(CustomSnackbar.showSnackBar(
                      message: 'Recipe added successfully',
                      backgroundColor: Colors.green,
                    ));
                    context.read<PhotoPickerBloc>().add(RemovePhotoPressed());
                  }
                },
                child: Center(
                  child: Column(
                    children: [
                      Visibility(
                        visible:
                            Provider.of<InternetConnectionStatus>(context) ==
                                InternetConnectionStatus.disconnected,
                        child: const InternetNotConnected(),
                      ),
                      Visibility(
                        visible:
                            Provider.of<InternetConnectionStatus>(context) ==
                                InternetConnectionStatus.connected,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(width: 48),
                                      Text(
                                        'Add new recipe',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 22,
                                            ),
                                      ),
                                      const RecipeInfoButton(),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  MealTextField(
                                    controller: _mealNameController,
                                    labelText: 'Meal name',
                                    hintText: _mealNameController.text.isEmpty
                                        ? ''
                                        : 'Meal name',
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 10),
                                  MealTextField(
                                    controller: _ingredientsController,
                                    labelText: 'Ingredients',
                                    hintText:
                                        _ingredientsController.text.isEmpty
                                            ? ''
                                            : 'Ingredients',
                                  ),
                                  const SizedBox(height: 10),
                                  MealTextField(
                                    controller: _descriptionController,
                                    labelText: 'Description',
                                    hintText:
                                        _descriptionController.text.isEmpty
                                            ? ''
                                            : 'Description',
                                  ),
                                  const SizedBox(height: 10),
                                  const MealCharacteristics(),
                                  const SizedBox(height: 10),
                                  MealPhotoPicker(
                                    imageUrlController: _imageUrlController,
                                  ),
                                  const SizedBox(height: 10),
                                  BlocBuilder<MealsBloc, MealsState>(
                                    builder: (context, state) {
                                      if (state is MealsInitial) {
                                        late PhotoType selectedPhotoType;
                                        File? photoFile;
                                        return BlocListener<PhotoPickerBloc,
                                            PhotoPickerState>(
                                          listener: (context, state) {
                                            if (state is FileLoaded) {
                                              selectedPhotoType =
                                                  state.selectedPhotoType;
                                              photoFile = state.imageFile;
                                            } else if (state is UrlLoaded) {
                                              selectedPhotoType = PhotoType.url;
                                            }
                                          },
                                          child: MaterialButton(
                                            color: Theme.of(context)
                                                .highlightColor,
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Save recipe',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<MealsBloc>()
                                                  .add(AddMealPressed(
                                                    mealName:
                                                        _mealNameController.text
                                                            .trim(),
                                                    ingredients:
                                                        _ingredientsController
                                                            .text
                                                            .trim(),
                                                    description:
                                                        _descriptionController
                                                            .text
                                                            .trim(),
                                                    imageUrl:
                                                        _imageUrlController.text
                                                            .trim(),
                                                    selectedPhotoType:
                                                        selectedPhotoType,
                                                    imageFile: photoFile,
                                                    complexity:
                                                        state.complexity,
                                                    isPublic: state.isPublic,
                                                  ));
                                            },
                                          ),
                                        );
                                      } else if (state is MealsLoading) {
                                        return const SpinKitThreeBounce(
                                          size: 25,
                                          color: Colors.white,
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  const SizedBox(height: 25)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
