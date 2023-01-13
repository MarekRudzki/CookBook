import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import 'src/features/account/screens/login_screen/login_screen.dart';
import '/src/features/account/account_provider.dart';
import '/src/features/meals/meals_provider.dart';
import 'src/config/firebase_options.dart';
import '/src/services/hive_services.dart';
import 'src/features/main_screen.dart';
import 'src/core/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  final bool isLogged = HiveServices().isLogged();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//TODO add l10n
  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ListenableProvider<AccountProvider>(create: (_) => AccountProvider()),
        ListenableProvider<MealsProvider>(create: (_) => MealsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return StreamProvider<InternetConnectionStatus>(
            initialData: InternetConnectionStatus.connected,
            create: (_) {
              return InternetConnectionChecker().onStatusChange;
            },
            child: MaterialApp(
              theme: theme.getTheme(),
              debugShowCheckedModeBanner: false,
              home: isLogged ? const MainScreen() : const LoginScreen(),
            ),
          );
        },
      ),
    ),
  );
}
