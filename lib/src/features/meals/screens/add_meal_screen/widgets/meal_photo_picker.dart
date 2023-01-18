// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../meals_provider.dart';

class MealPhotoPicker extends StatelessWidget {
  const MealPhotoPicker({
    super.key,
    required this.imageUrlController,
    required this.mealsProvider,
  });

  final TextEditingController imageUrlController;
  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.33,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).backgroundColor,
              width: 10,
            ),
          ),
          child: mealsProvider.selectedPhotoType != null
              ? mealsProvider.selectedPhotoType == PhotoType.url
                  ? FittedBox(
                      child: Image.network(mealsProvider.imageUrl == ''
                          ? imageUrlController.text
                          : mealsProvider.imageUrl),
                      fit: BoxFit.fill,
                    )
                  : Image.file(mealsProvider.imageFile!)
              : InkWell(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 60,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Theme.of(context).backgroundColor,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add photo:',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              const SizedBox(height: 10),
                              PhotoFromCamera(
                                mealsProvider: mealsProvider,
                              ),
                              const SizedBox(height: 10),
                              PhotoFromGallery(
                                mealsProvider: mealsProvider,
                              ),
                              const SizedBox(height: 10),
                              PhotoFromURL(
                                imageUrlController: imageUrlController,
                                mealsProvider: mealsProvider,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (mealsProvider.selectedPhotoType != null)
          ElevatedButton(
            onPressed: () {
              mealsProvider.removeCurrentPhoto();
              imageUrlController.clear();
            },
            child: const Text('Pick other photo'),
          )
        else
          const SizedBox.shrink()
      ],
    );
  }
}

class PhotoFromCamera extends StatelessWidget {
  const PhotoFromCamera({
    super.key,
    required this.mealsProvider,
  });

  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        'From Camera',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () async {
        final imagePicker = ImagePicker();
        final pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 480,
          maxWidth: 640,
        );
        if (pickedFile != null) {
          mealsProvider.setImage(
            image: File(pickedFile.path),
          );
          mealsProvider.changePhotoType(PhotoType.camera);
        }
        Navigator.of(context).pop();
      },
      style: const ButtonStyle().copyWith(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryColorDark.withOpacity(0.3),
        ),
      ),
    );
  }
}

class PhotoFromGallery extends StatelessWidget {
  const PhotoFromGallery({
    super.key,
    required this.mealsProvider,
  });

  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        'From Gallery',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: () async {
        final ImagePicker imagePicker = ImagePicker();
        final pickedImage = await imagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640,
        );
        if (pickedImage != null) {
          mealsProvider.setImage(
            image: File(pickedImage.path),
          );
          mealsProvider.changePhotoType(PhotoType.gallery);
        }
        Navigator.of(context).pop();
      },
      style: const ButtonStyle().copyWith(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryColorDark.withOpacity(0.3),
        ),
      ),
    );
  }
}

class PhotoFromURL extends StatelessWidget {
  const PhotoFromURL({
    super.key,
    required this.mealsProvider,
    required this.imageUrlController,
  });

  final TextEditingController imageUrlController;
  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        'From URL',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        const Text('Please insert URL'),
                        TextField(
                          controller: imageUrlController,
                          textAlign: TextAlign.center,
                        ),
                        if (context.select((MealsProvider mealsProvider) =>
                                mealsProvider.errorMessage) ==
                            '')
                          const SizedBox.shrink()
                        else
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              mealsProvider.errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await mealsProvider.validateUrl(
                                  context: context,
                                  urlController: imageUrlController,
                                );
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                imageUrlController.clear();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      style: const ButtonStyle().copyWith(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryColorDark.withOpacity(0.3),
        ),
      ),
    );
  }
}
