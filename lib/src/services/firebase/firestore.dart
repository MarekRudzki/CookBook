import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/src/domain/models/meal_model.dart';

import 'auth.dart';

class Firestore {
  final Auth _auth = Auth();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Firestore for user data storage
  Future<String> addUser(String username) async {
    final String? uid = _auth.uid;
    String errorText = '';

    if (username == '') {
      errorText = 'Field is empty';
      return errorText;
    }

    try {
      await _firestore.collection('users').doc(uid).set({
        'username': username,
      });
    } on Exception catch (e) {
      errorText = e.toString();
    }
    return errorText;
  }

  Future<String> getUsername() async {
    final String? uid = _auth.uid;
    String errorText = '';

    try {
      final collection = _firestore.collection('users');
      final docSnapshot = await collection.doc(uid).get();
      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();
        final value = data?['username'];
        errorText = value.toString();
      }
    } on Exception catch (e) {
      errorText = e.toString();
    }

    return errorText;
  }

  Future<String> deleteUserData(String uid) async {
    String errorText = '';

    try {
      final collection = _firestore.collection('users');
      await collection.doc(uid).delete();
    } on Exception catch (e) {
      errorText = e.toString();
    }
    return errorText;
  }

  //Firestore for meals data storage
  Future<String> addMeal({
    required String mealId,
    required String mealName,
    required List<String> ingredientsList,
    required List<String> descriptionList,
    required String complexity,
    required bool isPublic,
    required String authorId,
    required String authorName,
    required String imageUrl,
    required String generatedUid,
  }) async {
    String errorText = '';

    try {
      final mealCollection = _firestore.collection('meals');
      await mealCollection.doc(generatedUid).set({
        'mealId': mealId,
        'mealName': mealName,
        'ingredients': ingredientsList,
        'description': descriptionList,
        'complexity': complexity,
        'isPublic': isPublic,
        'authorId': authorId,
        'authorName': authorName,
        'image_url': imageUrl,
      });
    } on Exception catch (e) {
      errorText = e.toString();
    }

    try {
      final newMeal = [generatedUid];
      final usersCollection = _firestore.collection('users');
      await usersCollection.doc(authorId).update({
        'mealsList': FieldValue.arrayUnion(newMeal),
      });
    } on Exception catch (e) {
      errorText = e.toString();
    }

    return errorText;
  }

  Future<List<String>> getUserMealsId() async {
    final String? uid = _auth.uid;
    final List<String> userMeals = [];

    try {
      final collection = _firestore.collection('users');
      final docSnapshot = await collection.doc(uid).get();
      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();

        final dynamicList = data?['mealsList'] as List<dynamic>;
        for (final value in dynamicList) {
          final String meal = value.toString();
          userMeals.add(meal);
        }
      }
    } on Exception catch (e) {
      throw Exception(e);
    }

    return userMeals;
  }

  Future<List<MealModel>> getUserMeals() async {
    try {
      final collection = _firestore.collection('meals');
      final querySnapshot = await collection.get();

      return querySnapshot.docs
          .map(
            (doc) => MealModel(
              doc['mealId'] as String,
              doc['mealName'] as String,
              doc['description'] as List<dynamic>,
              doc['ingredients'] as List<dynamic>,
              doc['image_url'] as String,
              doc['authorName'] as String,
              doc['isPublic'] as bool,
              doc['complexity'] as String,
            ),
          )
          .toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
