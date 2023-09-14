import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';

import 'package:day_night_switcher/day_night_switcher.dart';

import 'package:cookbook/src/core/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LightDarkSwitcher extends StatelessWidget {
  const LightDarkSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Light',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 8),
        SizedBox(
          child: Center(
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                if (state is ThemeInitial) {
                  return const SpinKitThreeBounce(
                    size: 25,
                    color: Colors.white,
                  );
                } else if (state is ThemeLoaded) {
                  return DayNightSwitcher(
                    nightBackgroundColor: kDarkModeLighter.withBlue(180),
                    isDarkModeEnabled: state.isDarkTheme,
                    onStateChanged: (_) async {
                      if (state.isDarkTheme) {
                        AdaptiveTheme.of(context).setLight();
                        context.read<ThemeBloc>().add(SaveTheme(isDark: false));
                      } else {
                        AdaptiveTheme.of(context).setDark();
                        context.read<ThemeBloc>().add(SaveTheme(isDark: true));
                      }
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Dark',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
