part of 'theme_bloc.dart';

class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class SaveTheme extends ThemeEvent {
  final bool isDark;

  SaveTheme({required this.isDark});

  @override
  List<Object> get props => [isDark];
}
