import 'dart:ui';

import 'package:cookbook/src/core/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<SaveTheme>(_onSaveTheme);
  }

  Future<void> _onSaveTheme(
    SaveTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeInitial());
    List<Color> gradientColors;
    if (event.isDark) {
      gradientColors = [kDarkModeLighter, kDarkModeDarker];
    } else {
      gradientColors = [kLightModeLighter, kLightModeDarker];
    }

    emit(ThemeLoaded(
      isDarkTheme: event.isDark,
      gradient: gradientColors,
    ));
  }
}
