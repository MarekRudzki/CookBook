import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';
import '../../domain/models/meal_model.dart';

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

    final List<String> userMealsId = await getUserMealsId();

    try {
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'favoriteMeals': [],
        'mealsList': userMealsId,
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

  Future<String> updateMeal({
    required String mealId,
    required String mealName,
    required List<String> ingredientsList,
    required List<String> descriptionList,
    required String complexity,
    required bool isPublic,
    required String authorId,
    required String authorName,
    required String imageUrl,
  }) async {
    String errorText = '';

    try {
      final mealCollection = _firestore.collection('meals');
      await mealCollection.doc(mealId).update({
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

    return errorText;
  }

  Future<List<MealModel>> getMeals() async {
    try {
      final collection = _firestore.collection('meals');
      final querySnapshot = await collection.get();

      return querySnapshot.docs
          .map(
            (doc) => MealModel(
              id: doc['mealId'] as String,
              name: doc['mealName'] as String,
              description: doc['description'] as List<dynamic>,
              ingredients: doc['ingredients'] as List<dynamic>,
              imageUrl: doc['image_url'] as String,
              mealAuthor: doc['authorName'] as String,
              authorId: doc['authorId'] as String,
              isPublic: doc['isPublic'] as bool,
              complexity: doc['complexity'] as String,
            ),
          )
          .toList();
    } on Exception catch (e) {
      throw Exception(e);
    }
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

  Future<List<String>> getUserFavoriteMealsId() async {
    final String? uid = _auth.uid;
    final List<String> userFavoriteMealsIds = [];

    try {
      final collection = _firestore.collection('users');
      final docSnapshot = await collection.doc(uid).get();
      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();

        final dynamicList = data?['favoriteMeals'] as List<dynamic>;
        for (final value in dynamicList) {
          final String meal = value.toString();
          userFavoriteMealsIds.add(meal);
        }
      }
    } on Exception catch (e) {
      throw Exception(e);
    }

    return userFavoriteMealsIds;
  }

  Future<void> toggleMealFavorite(String mealId) async {
    final String? uid = _auth.uid;
    final List<String> mealList = [mealId];

    try {
      final collection = _firestore.collection('users').doc(uid);
      final docSnapshot = await collection.get();

      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();

        final dynamicList = data?['favoriteMeals'] as List<dynamic>;

        if (dynamicList.contains(mealId)) {
          await collection.update(
            {
              'favoriteMeals': FieldValue.arrayRemove(mealList),
            },
          );
        } else {
          await collection.update(
            {'favoriteMeals': FieldValue.arrayUnion(mealList)},
          );
        }
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteMeal({
    required String mealId,
    required String userId,
  }) async {
    final List<String> mealList = [mealId];

    try {
      final collection = _firestore.collection('meals');
      await collection.doc(mealId).delete();
    } on Exception catch (e) {
      throw Exception(e);
    }
    try {
      final collection = _firestore.collection('users').doc(userId);
      final docSnapshot = await collection.get();

      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();

        final dynamicList = data?['mealsList'] as List<dynamic>;

        if (dynamicList.contains(mealId)) {
          await collection.update(
            {
              'mealsList': FieldValue.arrayRemove(mealList),
            },
          );
        }
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateMealAuthor({required String newUsername}) async {
    final List<String> userMealsId = await getUserMealsId();
    for (final meal in userMealsId) {
      try {
        final collection = _firestore.collection('meals');
        await collection.doc(meal).update(
          {'authorName': newUsername},
        );
      } on Exception catch (e) {
        throw Exception(e);
      }
    }
  }
}
