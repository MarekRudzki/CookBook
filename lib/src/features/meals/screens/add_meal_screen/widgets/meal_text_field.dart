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
      style: Theme.of(context).textTheme.bodyText2,
      textInputAction: textInputAction,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).highlightColor,
          ),
        ),
        border: const OutlineInputBorder(),
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).highlightColor,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14,
        ),
        hintText: hintText,
      ),
    );
  }
}
