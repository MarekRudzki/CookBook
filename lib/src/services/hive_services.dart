import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  final _userBox = Hive.box('userBox');

  bool isLogged() {
    final email = _userBox.get('email');
    if (email != null) {
      return true;
    } else {
      return false;
    }
  }

  void setUser(String username) {
    _userBox.put('email', username.trim());
    _userBox.put('theme', 'light');
  }

  void removeUser() {
    _userBox.delete('email');
    _userBox.delete('theme');
  }

  void setTheme({required String theme}) {
    _userBox.put('theme', theme);
  } // TODO maybe use as List to get username and isLogged

  String getTheme() {
    final String theme;
    final bool hasTheme = _userBox.containsKey('theme');
    final String currentTheme = _userBox.get('theme').toString();
    if (!hasTheme || currentTheme == 'light') {
      return theme = 'light';
    } else {
      theme = 'dark';
    }
    return theme;
  }
}
