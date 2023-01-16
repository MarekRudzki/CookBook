import 'package:flutter/material.dart';

class LoginTextInputField extends StatelessWidget {
  const LoginTextInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscure = false,
    required this.icon,
    this.inputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String labelText;
  final bool obscure;
  final IconData icon;
  final TextInputAction inputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              obscureText: obscure,
              controller: controller,
              textInputAction: inputAction,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
