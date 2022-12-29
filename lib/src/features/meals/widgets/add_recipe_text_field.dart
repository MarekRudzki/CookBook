import 'package:flutter/material.dart';

class AddRecipeTextField extends StatelessWidget {
  const AddRecipeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.textInputAction = TextInputAction.newline,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
          ),
          hintText: hintText),
    );
  }
}
