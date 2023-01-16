import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.context,
  });

  final String text;
  final Function() onTap;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
            ),
          ),
        ),
      ),
    );
  }
}
