import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Future<void> getInstance() async {
  //   await SharedPreferences.getInstance();
  // }

  // Future<void> setTheme({required bool isDark}) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('darkTheme', isDark);
  // }

  // Future<bool> isDarkTheme() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final bool? isDark = prefs.getBool('darkTheme');
  //   if (isDark != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<bool> isLogged() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    if (email != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> setUser(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'email',
      username.trim(),
    );
  }

  Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
  }
}
