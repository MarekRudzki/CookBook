import 'src/presentation/screens/login/cubit/login_screen_cubit.dart';
import 'src/presentation/screens/login/login_screen.dart';
import 'src/presentation/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookbook/src/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('email');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    BlocProvider(
      create: (context) => LoginScreenCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: email == null ? const LoginScreen() : const MainScreen(),
      ),
    ),
  );
}
