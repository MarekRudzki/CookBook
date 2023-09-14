import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthFirestoreRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser({
    required String uid,
    required String username,
    required List<String> userMealsId,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'favoriteMeals': [],
        'mealsList': userMealsId,
      });
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> getUsername({
    required String uid,
  }) async {
    try {
      final collection = _firestore.collection('users');
      final docSnapshot = await collection.doc(uid).get();
      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();
        final value = data?['username'] as String;
        return value;
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
    return '';
  }

  Future<void> deleteUserData({
    required String uid,
  }) async {
    try {
      final collection = _firestore.collection('users');
      await collection.doc(uid).delete();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
