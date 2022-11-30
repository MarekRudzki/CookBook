import '../../widgets/login_action_button.dart';
import '../../widgets/login_text_input_field.dart';
import '../login_screen/cubit/login_screen_cubit.dart';
import '../main_screen/main_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmedPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
  }

  void showErrorDialog(BuildContext context, String errorText) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorText, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  void loadingSpinner(BuildContext context) {
    var loginCubit = BlocProvider.of<LoginScreenCubit>(context);
    loginCubit.switchLoading();
    loginCubit.state.isLoading
        ? showDialog(
            context: context,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          )
        : Navigator.of(context).pop();
  }

  void logIn(BuildContext context, [bool mounted = true]) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog(context, 'Email or password field is empty');
      return;
    }

    try {
      loadingSpinner(context);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        showErrorDialog(context, 'No Internet connection');
      } else if (e.code == "wrong-password") {
        return showErrorDialog(context, 'Please enter correct password');
      } else if (e.code == 'user-not-found') {
        showErrorDialog(context, 'User not found');
      } else if (e.code == 'too-many-requests') {
        return showErrorDialog(
            context, 'Too many attempts, please try again later');
      } else if (e.code == 'invalid-email') {
        return showErrorDialog(context, 'Email adress is not valid');
      } else {
        return showErrorDialog(context, 'Unknown error');
      }
      return;
    } finally {
      loadingSpinner(context);
      FocusManager.instance.primaryFocus?.unfocus();
    }

    _emailController.clear();
    _passwordController.clear();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var loginCubit = BlocProvider.of<LoginScreenCubit>(context);
    return BlocBuilder<LoginScreenCubit, LoginScreenState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background_login.png'),
                    fit: BoxFit.cover),
              ),
              child: loginCubit.state.isCreatingAccount
                  ? registerView(context)
                  : loginView(context),
            ),
          ),
        );
      },
    );
  }

  loginView(BuildContext context) {
    var loginCubit = BlocProvider.of<LoginScreenCubit>(context);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        ),
        LoginTextInputField(
          controller: _emailController,
          labelText: 'Enter your email',
          icon: Icons.email_outlined,
        ),
        LoginTextInputField(
          controller: _passwordController,
          labelText: 'Enter your password',
          obscure: true,
          inputAction: TextInputAction.done,
          icon: Icons.key,
        ),
        TextButton(
          onPressed: null,
          child: Text(
            'Forgot your password?',
            //TODO Apply password reset
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
        ActionButton(
          text: 'Login',
          context: context,
          onTap: () {
            logIn(context);
          },
        ),
        const SizedBox(
          height: 15,
        ),
        ActionButton(
          text: 'Register',
          context: context,
          onTap: () {
            loginCubit.switchLoginRegister();
          },
        ),
      ],
    );
  }

  registerView(BuildContext context) {
    var loginCubit = BlocProvider.of<LoginScreenCubit>(context);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.17,
        ),
        LoginTextInputField(
          controller: _nameController,
          labelText: 'Enter your name',
          icon: Icons.person,
        ),
        LoginTextInputField(
          controller: _emailController,
          labelText: 'Enter your email',
          icon: Icons.email_outlined,
        ),
        LoginTextInputField(
          controller: _passwordController,
          labelText: 'Enter your password',
          obscure: true,
          icon: Icons.key,
        ),
        LoginTextInputField(
          controller: _confirmedPasswordController,
          labelText: 'Confirm your password',
          obscure: true,
          inputAction: TextInputAction.done,
          icon: Icons.key,
        ),
        TextButton(
          onPressed: () {
            loginCubit.switchLoginRegister();
          },
          child: Text(
            'Already have an account? Try login',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        const SizedBox(height: 8),
        ActionButton(
          text: 'Register',
          context: context,
          onTap: () async {
            if (_emailController.text.contains('@') &&
                _emailController.text.length > 5 &&
                _passwordController.text.isNotEmpty &&
                _passwordController.text == _confirmedPasswordController.text) {
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text);
                //TODO add to local storage username
              } catch (error) {
                print(error);
              }
            }
          },
        ),
      ],
    );
  }
}
