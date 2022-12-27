import 'package:cookbook/src/features/account/account_provider.dart';
import 'package:cookbook/src/services/hive_services.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/core/theme_provider.dart';
import 'src/features/account/screens/login_screen.dart';
import 'src/config/firebase_options.dart';
import 'src/features/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  final bool isLogged = HiveServices().isLogged();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ListenableProvider<AccountProvider>(create: (_) => AccountProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            theme: theme.dark,
            debugShowCheckedModeBanner: false,
            home: isLogged ? const MainScreen() : const LoginScreen(),
          );
        },
      ),
    ),
  );
}
