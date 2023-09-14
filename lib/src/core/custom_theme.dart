import 'package:cookbook/src/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.white,
    primaryColorDark: Colors.grey,
    colorScheme: ColorScheme.dark(
      secondaryContainer: kLightModeLighter,
      error: Colors.red,
      background: kDarkModeLighter,
    ),
    cardColor: kDarkModeDarker,
    highlightColor: kDarkModeLighter,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.red),
      fillColor: MaterialStateProperty.all(Colors.transparent),
    ),
    textTheme: TextTheme(
      headlineSmall: const TextStyle(
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.oswald(
        color: Colors.white,
        fontSize: 16,
      ),
      bodySmall: GoogleFonts.robotoSlab(
        color: Colors.white,
        fontSize: 14,
      ),
      bodyLarge: GoogleFonts.oswald(
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

  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    primaryColorLight: Colors.grey,
    primaryColorDark: Colors.white,
    cardColor: kLightModeLighter,
    colorScheme: ColorScheme.light(
      secondaryContainer: kDarkModeLighter,
      onBackground: const Color.fromARGB(255, 82, 132, 70),
      error: const Color.fromARGB(255, 162, 38, 29),
      background: const Color.fromARGB(255, 82, 132, 70),
    ),
    highlightColor: kLightModeLighter,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.red),
      fillColor: MaterialStateProperty.all(Colors.transparent),
    ),
    textTheme: TextTheme(
      headlineSmall: const TextStyle(
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.oswald(
        color: Colors.white,
        fontSize: 16,
      ),
      bodySmall: GoogleFonts.robotoSlab(
        color: Colors.white,
        fontSize: 14,
      ),
      bodyLarge: GoogleFonts.oswald(
        color: Colors.white,
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
