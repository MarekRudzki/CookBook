import 'package:flutter/material.dart';

class AddMealTextField extends StatelessWidget {
  const AddMealTextField({
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
      textInputAction: textInputAction,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).highlightColor),
        ),
        border: const OutlineInputBorder(),
        floatingLabelStyle: TextStyle(color: Theme.of(context).highlightColor),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
