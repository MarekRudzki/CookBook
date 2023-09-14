import 'dart:io';

import 'package:cookbook/src/core/constants.dart';
import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/common_widgets/custom_snackbar.dart';
import 'package:cookbook/src/features/meals/domain/models/meal_model.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/photo_picker/photo_picker_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meal_characteristics.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meal_photo_picker.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/meal_text_field.dart';
import 'package:cookbook/src/features/meals/presentation/widgets/recipe_info_button.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cookbook/src/features/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    final Complexity complexity;
    if (widget.mealModel.complexity == 'Easy') {
      complexity = Complexity.easy;
    } else if (widget.mealModel.complexity == 'Medium') {
      complexity = Complexity.medium;
    } else {
      complexity = Complexity.hard;
    }

    context.read<MealsBloc>().add(MealCharacteristicsChanged(
          complexity: complexity,
          isPublic: widget.mealModel.isPublic,
        ));
    context.read<PhotoPickerBloc>().add(SetImageUrl(
          imageUrl: widget.mealModel.imageUrl,
          isSaveMode: false,
        ));

    String getIngredients() {
      final List<String> ingredinetsList = [];
      for (final ingredient in widget.mealModel.ingredients) {
        ingredinetsList.add(ingredient as String);
      }
      final String ingredients = ingredinetsList.join('\n');
      return ingredients;
    }

    String getDescription() {
      final List<String> descriptionList = [];
      for (final description in widget.mealModel.description) {
        final String descriptionConverted = description.toString().substring(3);
        descriptionList.add(descriptionConverted);
      }
      final String description = descriptionList.join('\n');
      return description;
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        context.read<MealsBloc>().add(UserFavoriteMealsIdRequested());
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              if (state is ThemeLoaded) {
                return Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: state.gradient,
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(CustomSnackbar.showSnackBar(
                          message: 'Recipe edited successfully',
                          backgroundColor: Colors.green,
                        ));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                      }
                    },
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
                                    context
                                        .read<MealsBloc>()
                                        .add(UserFavoriteMealsIdRequested());
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                Text(
                                  'Edit recipe',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 22,
                                      ),
                                ),
                                const RecipeInfoButton()
                              ],
                            ),
                            const SizedBox(height: 10),
                            MealTextField(
                              controller: _mealNameController
                                ..text = widget.mealModel.name,
                              labelText: 'Meal name',
                              hintText: _mealNameController.text.isEmpty
                                  ? ''
                                  : 'Meal name',
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),
                            MealTextField(
                              controller: _ingredientsController
                                ..text = getIngredients(),
                              labelText: 'Ingredients',
                              hintText: _ingredientsController.text.isEmpty
                                  ? ''
                                  : 'Ingredients',
                            ),
                            const SizedBox(height: 10),
                            MealTextField(
                              controller: _descriptionController
                                ..text = getDescription(),
                              labelText: 'Description',
                              hintText: _descriptionController.text.isEmpty
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
                                  PhotoType selectedPhotoType = PhotoType.url;
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
                                      color: Theme.of(context).highlightColor,
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
                                            .add(EditMealPressed(
                                              mealName: _mealNameController.text
                                                  .trim(),
                                              ingredients:
                                                  _ingredientsController.text
                                                      .trim(),
                                              description:
                                                  _descriptionController.text
                                                      .trim(),
                                              imageUrl: _imageUrlController.text
                                                      .trim()
                                                      .isEmpty
                                                  ? widget.mealModel.imageUrl
                                                  : _imageUrlController.text
                                                      .trim(),
                                              imageFile: photoFile,
                                              selectedPhotoType:
                                                  selectedPhotoType,
                                              complexity: state.complexity,
                                              isPublic: state.isPublic,
                                              mealId: widget.mealModel.id,
                                              mealAuthor:
                                                  widget.mealModel.mealAuthor,
                                              authorId:
                                                  widget.mealModel.authorId,
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
                            BlocConsumer<MealsBloc, MealsState>(
                              listener: (context, mealsState) {
                                if (mealsState is MealDeleted) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(CustomSnackbar.showSnackBar(
                                    message: 'Recipe deleted successfully',
                                    backgroundColor: Colors.green,
                                  ));
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ));
                                } else if (mealsState is MealsError) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(CustomSnackbar.showSnackBar(
                                    message: mealsState.errorMessage,
                                  ));
                                }
                              },
                              builder: (context, mealsState) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: MaterialButton(
                                    color: Theme.of(context).colorScheme.error,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete_forever,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
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
                                          return AlertDialog(
                                            title: Text(
                                              'Are your sure?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            backgroundColor: state.isDarkTheme
                                                ? kDarkModeLighter
                                                : kLightModeLighter,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    24, 20, 24, 0),
                                            content: const Text(
                                              softWrap: true,
                                              'Do you want to delete this recipe?',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      context
                                                          .read<MealsBloc>()
                                                          .add(
                                                              DeleteMealPressed(
                                                            mealId: widget
                                                                .mealModel.id,
                                                            userId: widget
                                                                .mealModel
                                                                .authorId,
                                                            imageUrl: widget
                                                                .mealModel
                                                                .imageUrl,
                                                          ));
                                                    },
                                                    icon: const Icon(
                                                      Icons.done,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
