import 'package:cookbook/src/features/account/account_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'src/features/login/cubit/login_cubit.dart';
import 'src/features/login/login_screen.dart';
import 'src/config/firebase_options.dart';
import 'src/features/main_screen.dart';
import 'src/services/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLogged = await SharedPrefs().isLogged();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    BlocProvider(
      create: (context) => LoginCubit(),
      child: ChangeNotifierProvider<AccountProvider>(
        create: (_) => AccountProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isLogged ? const MainScreen() : const LoginScreen(),
        ),
      ),
    ),
  );
}
