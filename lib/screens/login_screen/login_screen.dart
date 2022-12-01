import '../../constants.dart';
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
  final _passwordResetController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    _passwordResetController.dispose();
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

  void resetPassword(BuildContext context, [bool mounted = true]) {
    var loginCubit = BlocProvider.of<LoginScreenCubit>(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Reset your password?',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Enter the email adress associated with your account',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: darkThemeGradientFirst,
          actions: [
            Column(
              children: [
                TextField(
                  controller: _passwordResetController,
                  decoration: InputDecoration(
                    label: const Center(
                      child: Text('Input your email'),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white70),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<LoginScreenCubit, LoginScreenState>(
                    builder: (context, state) {
                      return state.errorMessage != ''
                          ? Text(
                              state.errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        String errorMsg = '';
                        if (_passwordResetController.text.trim().isEmpty) {
                          errorMsg = 'Field is empty';
                          loginCubit.addErrorMessage(errorMsg);
                          await Future.delayed(
                            const Duration(seconds: 3),
                          );
                          loginCubit.addErrorMessage('');
                          return;
                        }
                        try {
                          loadingSpinner(context);
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _passwordResetController.text.trim(),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email') {
                            errorMsg = 'Email adress is not valid';
                          } else if (e.code == 'user-not-found') {
                            errorMsg = 'User not found';
                          } else {
                            errorMsg = 'Unknown error';
                          }
                          return;
                        } finally {
                          loadingSpinner(context);
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (errorMsg != '') {
                            loginCubit.addErrorMessage(errorMsg);
                            await Future.delayed(
                              const Duration(seconds: 3),
                            );
                            loginCubit.addErrorMessage('');
                          }
                        }
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Check your mailbox',
                                style: TextStyle(color: Colors.white70),
                              ),
                              content: const Text(
                                'You should find link to reset your password in your mailbox.',
                                style: TextStyle(color: Colors.white70),
                              ),
                              backgroundColor: darkThemeGradientFirst,
                              actions: [
                                Center(
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _passwordResetController.clear();
                        loginCubit.addErrorMessage('');
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        );
      },
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
          onPressed: () {
            resetPassword(context);
          },
          child: Text(
            'Forgot your password?',
            //TODO Apply password reset
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
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
        const SizedBox(
          height: 14,
        ),
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
        const SizedBox(
          height: 5,
        ),
        TextButton(
          onPressed: () {
            loginCubit.switchLoginRegister();
          },
          child: Text(
            'Already have an account? Try login',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
