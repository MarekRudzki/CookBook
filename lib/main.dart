import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/features/account/cubit/account_cubit.dart';
import 'src/features/account/screens/login_screen.dart';
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
      create: (context) => AccountCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLogged ? const MainScreen() : const LoginScreen(),
      ),
    ),
  );
}
