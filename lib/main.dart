import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cookbook/src/core/custom_theme.dart';
import 'package:cookbook/src/core/di.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/change_password/change_password_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/change_username/change_username_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/delete_account/delete_account_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/login/login_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/logout/logout_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/register/register_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/screens/login_screen.dart';
import 'package:cookbook/src/features/home_screen.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/meals/meals_bloc.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/photo_picker/photo_picker_bloc.dart';
import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:cookbook/src/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()
            ..add(
              SaveTheme(isDark: savedThemeMode == AdaptiveThemeMode.dark),
            ),
        ),
        BlocProvider(create: (context) => getIt<MealsBloc>()),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<LoginBloc>()),
        BlocProvider(create: (context) => getIt<RegisterBloc>()),
        BlocProvider(create: (context) => getIt<PasswordResetBloc>()),
        BlocProvider(create: (context) => getIt<ChangePasswordBloc>()),
        BlocProvider(create: (context) => getIt<ChangeUsernameBloc>()),
        BlocProvider(create: (context) => getIt<DeleteAccountBloc>()),
        BlocProvider(create: (context) => getIt<LogoutBloc>()),
        BlocProvider(create: (context) => getIt<PhotoPickerBloc>()),
      ],
      child: StreamProvider<InternetConnectionStatus>(
        initialData: InternetConnectionStatus.connected,
        create: (_) {
          return InternetConnectionChecker().onStatusChange;
        },
        child: AdaptiveTheme(
          light: CustomTheme.lightTheme,
          dark: CustomTheme.darkTheme,
          initial: savedThemeMode ?? AdaptiveThemeMode.dark,
          builder: (light, dark) => MaterialApp(
            theme: light,
            darkTheme: dark,
            debugShowCheckedModeBanner: false,
            home: getIt<AuthBloc>().isUserLogged()
                ? const HomeScreen()
                : const LoginScreen(),
          ),
        ),
      ),
    ),
  );
}
