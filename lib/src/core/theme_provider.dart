import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _selectedTheme;
  // final SharedPrefs _sharedPrefs = SharedPrefs();
//TODO Save theme to shared prefs and retrieve it after closing app
  ThemeData dark = ThemeData.dark().copyWith();
  ThemeData light = ThemeData.light().copyWith();

  bool isDark() {
    if (_selectedTheme == dark) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> swapTheme() async {
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      //     await _sharedPrefs.setTheme(isDark: false);
    } else {
      _selectedTheme = dark;
      //     await _sharedPrefs.setTheme(isDark: true);
    }
    notifyListeners();
  }

  ThemeData getTheme() {
    if (_selectedTheme == null) {
      return dark;
    } else {
      return _selectedTheme!;
    }
  }
}
