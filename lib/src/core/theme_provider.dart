import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/hive_services.dart';
import '../core/constants.dart';

class ThemeProvider with ChangeNotifier {
  final HiveServices _hiveServices = HiveServices();

  ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    primaryColorDark: Colors.grey,
    errorColor: Colors.red,
    highlightColor: kLightGreen,
    textTheme: TextTheme(
      bodyText1: const TextStyle(
        color: Colors.white,
      ),
      headline1: GoogleFonts.oswald(
        color: Colors.white,
        fontSize: 18,
      ),
      bodyText2: GoogleFonts.robotoSlab(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: kLightBlue),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );

  ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    primaryColorDark: Colors.grey,
    errorColor: Colors.orange,
    highlightColor: Colors.blueAccent,
    textTheme: TextTheme(
      bodyText1: const TextStyle(
        color: Colors.white,
      ),
      headline1: GoogleFonts.oswald(
        color: Colors.white,
        fontSize: 18,
      ),
      bodyText2: GoogleFonts.robotoSlab(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: kLightGreen),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );

  void swapTheme() {
    final String currentTheme = _hiveServices.getTheme();
    if (currentTheme == 'dark') {
      _hiveServices.setTheme(theme: 'light');
    } else {
      _hiveServices.setTheme(theme: 'dark');
    }

    notifyListeners();
  }

  bool isDark() {
    final String currentTheme = _hiveServices.getTheme();
    if (currentTheme == 'dark') {
      return true;
    } else {
      return false;
    }
  }

  ThemeData getTheme() {
    final String currentTheme = _hiveServices.getTheme();
    if (currentTheme == 'light') {
      return light;
    } else {
      return dark;
    }
  }

  List<Color> getGradient() {
    List<Color> gradientColors;
    if (isDark()) {
      gradientColors = [kLightBlue, kDartBlue];
    } else {
      gradientColors = [kLightGreen, kDarkGreen];
    }
    return gradientColors;
  }
}
