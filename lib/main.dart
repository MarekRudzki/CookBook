import 'package:cookbook/screens/login_screen/cubit/login_screen_cubit.dart';
import 'package:cookbook/screens/login_screen/login_screen.dart';
import 'package:cookbook/screens/main_screen/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

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
