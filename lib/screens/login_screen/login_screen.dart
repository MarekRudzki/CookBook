import '../login_screen/cubit/login_screen_cubit.dart';
import '../main_screen/main_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/widgets/login_action_button.dart';
import '/widgets/login_text_input_field.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorText),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  void logIn(BuildContext context, Future<void> switchLoading,
      [bool mounted = true]) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        switchLoading;
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        switchLoading;
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
      }
    } else {
      showErrorDialog(context, 'Email or password field is empty');
      return;
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
              child: Column(
                children: [
                  SizedBox(
                    height: loginCubit.state.isCreatingAccount
                        ? MediaQuery.of(context).size.height * 0.17
                        : MediaQuery.of(context).size.height * 0.25,
                  ),
                  loginCubit.state.isCreatingAccount
                      ? LoginTextInputField(
                          controller: _nameController,
                          labelText: 'Enter your name',
                          obscure: false,
                          inputAction: TextInputAction.next,
                          icon: Icons.person,
                        )
                      : const SizedBox.shrink(),
                  LoginTextInputField(
                    controller: _emailController,
                    labelText: 'Enter your email',
                    obscure: false,
                    inputAction: TextInputAction.next,
                    icon: Icons.email_outlined,
                  ),
                  LoginTextInputField(
                    controller: _passwordController,
                    labelText: 'Enter your password',
                    obscure: true,
                    inputAction: loginCubit.state.isCreatingAccount
                        ? TextInputAction.next
                        : TextInputAction.done,
                    icon: Icons.key,
                  ),
                  !loginCubit.state.isCreatingAccount
                      ? const SizedBox.shrink()
                      : LoginTextInputField(
                          controller: _confirmedPasswordController,
                          labelText: 'Confirm your password',
                          obscure: true,
                          inputAction: TextInputAction.done,
                          icon: Icons.key,
                        ),
                  loginCubit.state.isCreatingAccount
                      ? TextButton(
                          onPressed: () {
                            loginCubit.switchToRegister();
                          },
                          child: Text(
                            'Already have an account? Try login',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        )
                      : TextButton(
                          onPressed: null,
                          child: Text(
                            'Forgot your password?',
                            //TODO Apply password reset
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                  loginCubit.state.isCreatingAccount
                      ? const SizedBox.shrink()
                      : const SizedBox(
                          height: 25,
                        ),
                  loginCubit.state.isCreatingAccount
                      ? const SizedBox.shrink()
                      : ActionButton(
                          text: 'Login',
                          onTap: () {
                            logIn(
                              context,
                              loginCubit.switchLoading(),
                            );
                          }),
                  loginCubit.state.isCreatingAccount
                      ? const SizedBox(height: 8)
                      : const SizedBox(
                          height: 15,
                        ),
                  loginCubit.state.isCreatingAccount
                      ? ActionButton(
                          text: 'Register',
                          onTap: () async {
                            if (_emailController.text.contains('@') &&
                                _emailController.text.length > 5 &&
                                _passwordController.text.isNotEmpty &&
                                _passwordController.text ==
                                    _confirmedPasswordController.text) {
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                //TODO add to local storage username
                              } catch (error) {
                                print(error);
                              }
                            }
                          },
                        )
                      : ActionButton(
                          text: 'Register',
                          onTap: () {
                            loginCubit.switchToRegister();
                          }),
                  ActionButton(
                    text: 'pushtomain',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
