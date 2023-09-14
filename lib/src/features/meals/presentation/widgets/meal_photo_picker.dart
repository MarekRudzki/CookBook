// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/photo_picker/photo_picker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:image_picker/image_picker.dart';

class MealPhotoPicker extends StatelessWidget {
  const MealPhotoPicker({
    super.key,
    required this.imageUrlController,
  });

  final TextEditingController imageUrlController;

  @override
  Widget build(BuildContext context) {
    context.read<PhotoPickerBloc>().add(RemovePhotoPressed());
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.33,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.background,
              width: 10,
            ),
          ),
          child: BlocBuilder<PhotoPickerBloc, PhotoPickerState>(
            builder: (context, state) {
              if (state is PhotoPickerInitial) {
                return InkWell(
                  child: const Icon(
                    Icons.add_a_photo,
                    size: 60,
                    color: Colors.white,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add photo:',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 10),
                              const PhotoFromCamera(),
                              const SizedBox(height: 10),
                              const PhotoFromGallery(),
                              const SizedBox(height: 10),
                              PhotoFromURL(
                                imageUrlController: imageUrlController,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is UrlLoaded) {
                return GridTile(
                  child: FittedBox(
                    child: Image.network(state.imageUrl),
                  ),
                  footer: Container(
                    color: Colors.black38,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<PhotoPickerBloc>()
                              .add(RemovePhotoPressed());
                        },
                        child: const Text(
                          'Pick other photo',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is FileLoaded) {
                return GridTile(
                  child: FittedBox(
                    child: Image.file(state.imageFile),
                  ),
                  footer: Container(
                    color: Colors.black38,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<PhotoPickerBloc>()
                              .add(RemovePhotoPressed());
                          imageUrlController.clear();
                        },
                        child: const Text(
                          'Pick other photo',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is PhotoPickerLoading) {
                return const SpinKitThreeBounce(
                  size: 25,
                  color: Colors.white,
                );
              } else if (state is PhotoPickerError) {
                return Center(
                  child: Column(
                    children: [
                      Text(
                        state.errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<PhotoPickerBloc>()
                              .add(RemovePhotoPressed());
                          imageUrlController.clear();
                        },
                        child: const Text('Pick other photo'),
                      )
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        )
      ],
    );
  }
}

class PhotoFromCamera extends StatelessWidget {
  const PhotoFromCamera({super.key});

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
          context.read<PhotoPickerBloc>().add(SetImageFile(
                imageFile: File(pickedFile.path),
                selectedPhotoType: PhotoType.camera,
              ));
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
  const PhotoFromGallery({super.key});

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
          context.read<PhotoPickerBloc>().add(SetImageFile(
                imageFile: File(pickedImage.path),
                selectedPhotoType: PhotoType.gallery,
              ));
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
    required this.imageUrlController,
  });

  final TextEditingController imageUrlController;

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
              backgroundColor: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<PhotoPickerBloc, PhotoPickerState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            const Text('Please insert URL'),
                            TextField(
                              controller: imageUrlController,
                              textAlign: TextAlign.center,
                            ),
                            if (state is PhotoPickerError)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.errorMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<PhotoPickerBloc>().add(
                                        SetImageUrl(
                                            imageUrl: imageUrlController.text
                                                .trim()));

                                    Navigator.of(context).pop();
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
                        );
                      },
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
