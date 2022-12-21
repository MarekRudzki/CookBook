import 'package:flutter/material.dart';

import '/src/services/firebase/firestore.dart';

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
