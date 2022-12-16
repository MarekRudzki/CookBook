import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/config/firebase_options.dart';
import 'src/services/shared_prefs.dart';
import 'src/presentation/screens/login/cubit/login_screen_cubit.dart';
import 'src/presentation/screens/login/login_screen.dart';
import 'src/presentation/screens/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLogged = await SharedPrefs().isLogged();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    BlocProvider(
      create: (context) => LoginScreenCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLogged ? const MainScreen() : const LoginScreen(),
      ),
    ),
  );
}
