import 'package:flutter/material.dart';

import '../widgets/login_action_button.dart';
import '../widgets/login_text_input_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTap,
    required this.onRegisterTap,
    required this.onPswResetTap,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function() onLoginTap;
  final Function() onRegisterTap;
  final Function() onPswResetTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        ),
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
          onPressed: onPswResetTap,
          child: Text(
            'Forgot your password?',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ),
        ActionButton(text: 'Login', context: context, onTap: onLoginTap),
        const SizedBox(
          height: 15,
        ),
        ActionButton(text: 'Register', context: context, onTap: onRegisterTap),
      ],
    );
  }
}