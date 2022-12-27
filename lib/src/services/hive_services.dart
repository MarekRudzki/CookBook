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
  }

  String? getUserEmail() {
    final String _userEmail = _userBox.get('email').toString();
    return _userEmail;
  }

  void removeUser() {
    _userBox.delete('email');
  }

  bool isDarkTheme({required String userEmail}) {
    final isDark = _userBox.get('{$userEmail}_isDark');
    if (isDark == null) {
      return false;
    } else {
      return true;
    }
  }

  void setTheme({required bool isDark, required String userEmail}) {
    _userBox.put('${userEmail}_isDark', isDark);
  }

  void deleteTheme({required String userEmail}) {
    final hasTheme = _userBox.get('{$userEmail}_isDark');
    if (hasTheme != null) {
      _userBox.delete('{$userEmail}_isDark');
    }
  }
}
