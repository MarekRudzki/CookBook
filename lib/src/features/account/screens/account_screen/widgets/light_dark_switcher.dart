import 'package:flutter/material.dart';

import 'package:day_night_switcher/day_night_switcher.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/theme_provider.dart';

class LightDarkSwitcher extends StatelessWidget {
  const LightDarkSwitcher({
    super.key,
    required this.theme,
  });

  final ThemeProvider theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Light',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          child: Center(
            child: DayNightSwitcher(
              nightBackgroundColor: kDarkModeLighter.withBlue(180),
              isDarkModeEnabled: theme.isDark(),
              onStateChanged: (_) {
                theme.swapTheme();
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Dark',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
