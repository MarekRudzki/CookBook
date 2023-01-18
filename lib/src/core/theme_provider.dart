import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../services/hive_services.dart';
import '../core/constants.dart';

class ThemeProvider with ChangeNotifier {
  final HiveServices _hiveServices = HiveServices();

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
    if (currentTheme == 'dark') {
      return dark;
    } else {
      return light;
    }
  }

  List<Color> getGradient() {
    List<Color> gradientColors;
    if (isDark()) {
      gradientColors = [kDarkModeLighter, kDarkModeDarker];
    } else {
      gradientColors = [kLightModeLighter, kLightModeDarker];
    }
    return gradientColors;
  }

  ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    primaryColorDark: Colors.grey,
    errorColor: Colors.red,
    backgroundColor: kDarkModeLighter,
    cardColor: kDarkModeDarker,
    highlightColor: Colors.blueAccent,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.red),
      fillColor: MaterialStateProperty.all(Colors.transparent),
    ),
    textTheme: TextTheme(
      bodyText1: const TextStyle(
        color: Colors.white,
      ),
      headline1: GoogleFonts.oswald(
        color: Colors.white,
        fontSize: 16,
      ),
      bodyText2: GoogleFonts.robotoSlab(
        color: Colors.white,
        fontSize: 14,
      ),
      headline3: GoogleFonts.oswald(
        color: Colors.white,
        fontSize: 17,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: kDarkModeLighter),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );

  ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.blue.shade400,
    primaryColorLight: Colors.grey,
    primaryColorDark: Colors.blue,
    backgroundColor: kLightModeLighter,
    errorColor: Colors.red,
    highlightColor: Colors.blue,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.red),
      fillColor: MaterialStateProperty.all(Colors.transparent),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.blue.shade400,
      ),
      headline1: GoogleFonts.oswald(
        color: Colors.blue.shade400,
        fontSize: 16,
      ),
      bodyText2: GoogleFonts.robotoSlab(
        color: Colors.blue.shade400,
        fontSize: 14,
      ),
      headline3: GoogleFonts.oswald(
        color: Colors.blue.shade400,
        fontSize: 17,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: kLightModeDarker.withAlpha(155)),
    ),
    iconTheme: IconThemeData(
      color: Colors.blue.shade400,
    ),
  );
}
