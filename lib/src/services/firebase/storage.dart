import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final ref = FirebaseStorage.instance.ref().child('meals_images');

  Future<String> uploadImage(
      {required String mealId, required File image}) async {
    String errorText = '';
    try {
      await ref.child('Meal_${mealId}.jpg').putFile(image);
    } on FirebaseException catch (e) {
      errorText = e.code;
    }
    return errorText;
  }
}
