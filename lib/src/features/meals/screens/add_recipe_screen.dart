import 'package:cookbook/src/features/common_widgets/error_handling.dart';
import 'package:flutter/material.dart';

import '../../../core/theme_provider.dart';
import '../widgets/add_recipe_meal_characteristics.dart';
import '../widgets/add_recipe_photo_picker.dart';
import '../widgets/add_recipe_text_field.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  late final TextEditingController _mealNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _imageUrlController;

  final ThemeProvider _themeProvider = ThemeProvider();
  final ErrorHandling _errorHandling = ErrorHandling();

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
                Text(
                  'Add new recipe',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 25,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AddRecipeTextField(
                  controller: _mealNameController,
                  textInputAction: TextInputAction.next,
                  hintText: 'Meal name',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddRecipeTextField(
                  controller: _ingredientsController,
                  hintText: 'Ingredients',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddRecipeTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
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
                MaterialButton(
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
                      _errorHandling.toggleRecipeLoadingSpinner(context);
                      await Future.delayed(
                        const Duration(seconds: 2),
                      );
                      FocusManager.instance.primaryFocus?.unfocus();
                      _errorHandling.toggleRecipeLoadingSpinner(context);
                    }),
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





 // int i = 1;

                      // const LineSplitter ls = LineSplitter();
                      // final List<String> trys =
                      //     ls.convert(_descriptionController.text);
                      // for (var element in trys) {
                      //   element = '${i}) $element';
                      //   i++;
                      //   description.add(element);
                      // }