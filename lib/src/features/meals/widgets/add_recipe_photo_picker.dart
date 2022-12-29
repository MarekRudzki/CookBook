import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../meals_provider.dart';

class PhotoPicker extends StatelessWidget {
  const PhotoPicker({
    super.key,
    required TextEditingController imageUrlController,
  }) : _imageUrlController = imageUrlController;

  final TextEditingController _imageUrlController;

  @override
  Widget build(BuildContext context) {
    return Consumer<MealsProvider>(
      builder: (context, meals, _) {
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.33,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: kLightBlue,
                  width: 10,
                ),
              ),
              child: meals.selectedPhotoType != null
                  ? meals.selectedPhotoType == PhotoType.url
                      ? FittedBox(
                          child: Image.network(_imageUrlController.text),
                          fit: BoxFit.fill,
                        )
                      : Image.file(meals.imageFile!)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Choose a photo:',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(height: 10),
                        PhotoFromCamera(
                          meals: meals,
                        ),
                        const SizedBox(height: 10),
                        PhotoFromGallery(
                          meals: meals,
                        ),
                        const SizedBox(height: 10),
                        PhotoFromURL(
                          imageUrlController: _imageUrlController,
                          meals: meals,
                        ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (meals.selectedPhotoType != null)
              ElevatedButton(
                onPressed: () {
                  meals.removeCurrentPhoto();
                  _imageUrlController.clear();
                },
                child: const Text('Pick other photo'),
              )
            else
              const SizedBox.shrink()
          ],
        );
      },
    );
  }
}

class PhotoFromCamera extends StatelessWidget {
  const PhotoFromCamera({
    super.key,
    required this.meals,
  });

  final MealsProvider meals;

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
          meals.setImage(
            File(pickedFile.path),
          );
          meals.changePhotoType(PhotoType.camera);
        }
      },
    );
  }
}

class PhotoFromGallery extends StatelessWidget {
  const PhotoFromGallery({
    super.key,
    required this.meals,
  });

  final MealsProvider meals;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        'From Gallery',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () async {
        final ImagePicker imagePicker = ImagePicker();
        final pickedImage = await imagePicker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640,
        );
        if (pickedImage != null) {
          meals.setImage(
            File(pickedImage.path),
          );
          meals.changePhotoType(PhotoType.gallery);
        }
      },
    );
  }
}

class PhotoFromURL extends StatelessWidget {
  const PhotoFromURL({
    super.key,
    required TextEditingController imageUrlController,
    required this.meals,
  }) : _imageUrlController = imageUrlController;

  final TextEditingController _imageUrlController;
  final MealsProvider meals;

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
                          controller: _imageUrlController,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                meals.changePhotoType(PhotoType.url);
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _imageUrlController.clear();
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
    );
  }
}
