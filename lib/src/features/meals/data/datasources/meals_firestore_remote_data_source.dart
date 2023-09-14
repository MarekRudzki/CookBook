import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MealsFirestoreRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMeal({
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
      throw Exception(e.toString());
    }

    try {
      final newMeal = [generatedUid];
      final usersCollection = _firestore.collection('users');
      await usersCollection.doc(authorId).update({
        'mealsList': FieldValue.arrayUnion(newMeal),
      });
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateMeal({
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
      throw Exception(e.toString());
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMeals() async {
    try {
      final collection = _firestore.collection('meals');
      final querySnapshot = await collection.get();

      return querySnapshot.docs;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<String>> getUserMealsId({
    required String uid,
  }) async {
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
      throw Exception(e.toString());
    }

    return userMeals;
  }

  Future<List<String>> getUserFavoriteMealsId({
    required String uid,
  }) async {
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
      throw Exception(e.toString());
    }

    return userFavoriteMealsIds;
  }

  Future<void> toggleMealFavorite({
    required String mealId,
    required String uid,
  }) async {
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
      throw Exception(e.toString());
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
      throw Exception(e.toString());
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
      throw Exception(e.toString());
    }
  }

  Future<void> updateMealAuthor({
    required String newUsername,
    required String uid,
  }) async {
    final List<String> userMealsId = await getUserMealsId(uid: uid);
    for (final meal in userMealsId) {
      try {
        final collection = _firestore.collection('meals');
        await collection.doc(meal).update(
          {'authorName': newUsername},
        );
      } on Exception catch (e) {
        throw Exception(e.toString());
      }
    }
  }
}
