import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addUser(String username, String uid) async {
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
}
