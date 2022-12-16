import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
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
