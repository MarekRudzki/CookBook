import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class Firestore {
  final Auth _auth = Auth();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addUser(String username) async {
    final String? uid = _auth.uid;
    String errorText = '';
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
    String returnValue = '';

    try {
      final collection = _firestore.collection('users');
      final docSnapshot = await collection.doc(uid).get();
      if (docSnapshot.exists) {
        final Map<String, dynamic>? data = docSnapshot.data();
        final value = data?['username'];
        returnValue = value.toString();
      }
    } on Exception catch (e) {
      returnValue = e.toString();
    }

    return returnValue;
  }
}
