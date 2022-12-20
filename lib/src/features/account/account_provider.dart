import 'package:cookbook/src/services/firebase/firestore.dart';
import 'package:flutter/material.dart';

class AccountProvider with ChangeNotifier {
  final Firestore _firestore = Firestore();
  String username = '';
  String email = '';

  Future<void> setUsername() async {
    await _firestore.getUsername().then((value) {
      username = value;
    });
    notifyListeners();
  }

  void changeUsername(String value) {
    username = value;
    notifyListeners();
  }
}
