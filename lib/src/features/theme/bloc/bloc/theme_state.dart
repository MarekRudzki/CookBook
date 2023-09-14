part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {
  @override
  List<Object> get props => [];
}

class ThemeLoaded extends ThemeState {
  final bool isDarkTheme;
  final List<Color> gradient;

  ThemeLoaded({
    required this.isDarkTheme,
    required this.gradient,
  });

  @override
  List<Object> get props => [
        isDarkTheme,
        gradient,
      ];
}
