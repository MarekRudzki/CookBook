import 'dart:io';

import 'package:cookbook/src/core/enums.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MealsStorageRemoteDataSource {
  final ref = FirebaseStorage.instance.ref().child('meals_images');

  Future<String> getUrl({
    required String mealId,
  }) async {
    final String url = await ref.child('${mealId}.jpg').getDownloadURL();
    return url;
  }

  Future<void> uploadImage({
    required String mealId,
    required File image,
    required PhotoType selectedPhotoType,
  }) async {
    if (selectedPhotoType == PhotoType.url) return;

    try {
      await ref.child('${mealId}.jpg').putFile(image);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> updateImage({
    required String mealId,
    required File image,
    required PhotoType selectedPhotoType,
  }) async {
    if (selectedPhotoType == PhotoType.url) {
      try {
        await deleteImage(imageId: mealId);
      } on FirebaseException catch (e) {
        throw Exception(e.code);
      }
    }

    try {
      await ref.child('${mealId}.jpg').putFile(image);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteImage({
    required String imageId,
  }) async {
    try {
      await ref.child('${imageId}.jpg').delete();
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }
}
