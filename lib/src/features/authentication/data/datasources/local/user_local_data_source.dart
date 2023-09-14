import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserLocalDataSource {
  final _userBox = Hive.box('userBox');

  bool isLogged() {
    final email = _userBox.get('email');
    if (email != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> setUserEmail(String username) async {
    await _userBox.put('email', username.trim());
  }

  String getUserEmail() {
    final String email = _userBox.get('email').toString();
    return email;
  }

  Future<void> removeUserEmail() async {
    await _userBox.delete('email');
  }

  Future<void> setUsername({required String username}) async {
    final String email = _userBox.get('email').toString();
    await _userBox.put('${email}_username', username);
  }

  String getUsername() {
    final String email = _userBox.get('email').toString();
    final bool usernameExists = _userBox.containsKey('${email}_username');
    String username;
    if (usernameExists) {
      username = _userBox.get('${email}_username').toString();
    } else {
      username = 'no-username';
    }
    return username;
  }

  Future<void> removeUsername() async {
    final String email = _userBox.get('email').toString();
    await _userBox.delete('${email}_username');
  }
}
