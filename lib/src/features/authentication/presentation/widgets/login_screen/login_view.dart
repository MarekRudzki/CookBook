import 'package:cookbook/src/features/authentication/presentation/blocs/login/login_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/login_screen/login_action_button.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/login_screen/login_text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
    required this.state,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTap,
    required this.onRegisterTap,
    required this.onPasswordResetTap,
  });

  final LoginState state;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function() onLoginTap;
  final void Function() onRegisterTap;
  final void Function() onPasswordResetTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 18, 76, 135).withOpacity(0.75),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              LoginTextInputField(
                controller: emailController,
                labelText: 'Enter your email',
                icon: Icons.email_outlined,
              ),
              LoginTextInputField(
                controller: passwordController,
                labelText: 'Enter your password',
                obscure: true,
                inputAction: TextInputAction.done,
                icon: Icons.key,
              ),
              TextButton(
                onPressed: onPasswordResetTap,
                child: Text('Forgot your password?',
                    style: const TextStyle().copyWith(
                      color: Colors.blueAccent,
                      fontSize: 14,
                    )),
              ),
              if (state is LoginLoading)
                const SpinKitThreeBounce(
                  size: 25,
                  color: Colors.white,
                )
              else
                ActionButton(
                  text: 'Login',
                  context: context,
                  onTap: onLoginTap,
                ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: onRegisterTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
