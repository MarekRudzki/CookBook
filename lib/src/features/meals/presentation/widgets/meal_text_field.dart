import 'package:flutter/material.dart';

class MealTextField extends StatelessWidget {
  const MealTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.textInputAction = TextInputAction.newline,
    required this.hintText,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: const TextStyle(
        color: Colors.white,
      ),
      textInputAction: textInputAction,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: const OutlineInputBorder(),
        floatingLabelStyle: const TextStyle(
          color: Colors.white,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        hintText: hintText,
      ),
    );
  }
}
