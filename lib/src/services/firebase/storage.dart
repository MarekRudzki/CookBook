import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../src/features/meals/meals_provider.dart';

class Storage {
  final ref = FirebaseStorage.instance.ref().child('meals_images');

  Future<String> uploadImage({
    String? mealId,
    File? image,
    MealsProvider? mealsProvider,
  }) async {
    String errorText = '';
    if (mealsProvider!.selectedPhotoType == PhotoType.url) return errorText;
    print('sdsd');

    try {
      await ref.child('Meal_${mealId}.jpg').putFile(image!);
    } on FirebaseException catch (e) {
      errorText = e.code;
    }
    return errorText;
  }

  Future<String> getUrl({required String mealId}) async {
    final String url = await ref.child('Meal_${mealId}.jpg').getDownloadURL();
    return url;
  }
}
