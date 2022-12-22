import 'package:cookbook/src/features/account/account_provider.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'src/core/theme_provider.dart';
import 'src/features/account/screens/login_screen.dart';
import 'src/config/firebase_options.dart';
import 'src/features/main_screen.dart';
import 'src/services/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLogged = await SharedPrefs().isLogged();
  //final bool isDarkTheme = await SharedPrefs().isDarkTheme();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ListenableProvider<AccountProvider>(create: (_) => AccountProvider()),
        ListenableProvider<AccountProvider>(create: (_) => AccountProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, child) {
          return MaterialApp(
            theme: theme.getTheme(),
            debugShowCheckedModeBanner: false,
            home: isLogged ? const MainScreen() : const LoginScreen(),
          );
        },
      ),
    ),
  );
}
