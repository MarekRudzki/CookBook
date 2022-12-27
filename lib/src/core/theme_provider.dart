import 'package:flutter/material.dart';

import '../services/hive_services.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _selectedTheme;

  final HiveServices _hiveServices = HiveServices();

  ThemeData dark = ThemeData.dark().copyWith(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );

  ThemeData light = ThemeData.light().copyWith(
    iconTheme: const IconThemeData(
      color: Colors.blue,
    ),
    scaffoldBackgroundColor: Colors.grey.shade300,
  );

  void swapTheme() {
    final String? userEmail = _hiveServices.getUserEmail();
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      _hiveServices.setTheme(
        isDark: false,
        userEmail: userEmail!,
      );
    } else {
      _selectedTheme = dark;
      _hiveServices.setTheme(
        isDark: true,
        userEmail: userEmail!,
      );
    }
    notifyListeners();
  }

  bool isDark() {
    if (_selectedTheme == dark) {
      return true;
    } else {
      return false;
    }
  }

  // ThemeData getTheme(SharedPrefs prefs) {
  //   final bool isDark = prefs.isDarkTheme(userEmail: 'marek@test.pl');
  //   if (_selectedTheme == null) {
  //     return dark;
  //   } else {
  //     return _selectedTheme!;
  //   }
  // }
}
