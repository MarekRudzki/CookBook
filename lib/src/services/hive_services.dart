import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  final _userBox = Hive.box('userBox');

  ///
  ///// User services
  ///
  bool isLogged() {
    final email = _userBox.get('email');
    if (email != null) {
      return true;
    } else {
      return false;
    }
  }

  /// Email
  void setUserEmail(String username) {
    _userBox.put('email', username.trim());
  }

  String getUserEmail() {
    final String email = _userBox.get('email').toString();
    return email;
  }

  void removeUserEmail() {
    _userBox.delete('email');
  }

  /// Username

  void setUsername({required String username}) {
    final String email = _userBox.get('email').toString();
    _userBox.put('${email}_username', username);
  }

  String getUsername() {
    final String email = _userBox.get('email').toString();
    final bool usernameExists = _userBox.containsKey('${email}_username');
    String username = '';
    if (usernameExists) {
      username = _userBox.get('${email}_username').toString();
    } else {
      username = 'no-username';
    }
    return username;
  }

  void removeUsername() {
    final String email = _userBox.get('email').toString();
    _userBox.delete('${email}_username');
  }

  ///
  ///// Theme services
  ///

  void setTheme({required String theme}) {
    final String email = _userBox.get('email').toString();
    _userBox.put('${email}_theme', theme);
  }

  String getTheme() {
    final String email = _userBox.get('email').toString();
    final String theme;
    final bool hasTheme = _userBox.containsKey('${email}_theme');
    final String currentTheme = _userBox.get('${email}_theme').toString();
    if (!hasTheme || currentTheme == 'light') {
      return theme = 'light';
    } else {
      theme = 'dark';
    }
    return theme;
  }
}
