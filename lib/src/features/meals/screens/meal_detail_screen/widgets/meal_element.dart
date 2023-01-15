import 'dart:async';

import 'package:flutter/material.dart';

class MealElement extends StatefulWidget {
  const MealElement({
    super.key,
    required this.elementText,
  });

  final String elementText;

  @override
  State<MealElement> createState() => _MealElementState();
}

class _MealElementState extends State<MealElement> {
  final StreamController<bool> _checkBoxController = StreamController();
  Stream<bool> get _checkBoxStream => _checkBoxController.stream;

  @override
  void dispose() {
    _checkBoxController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).highlightColor,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.elementText,
              ),
            ),
            const VerticalDivider(
              width: 5,
              color: Colors.grey,
            ),
            StreamBuilder(
              stream: _checkBoxStream,
              initialData: false,
              builder: (context, snapshot) {
                return Checkbox(
                  side: BorderSide(color: Theme.of(context).highlightColor),
                  checkColor: Theme.of(context).highlightColor,
                  value: snapshot.data,
                  onChanged: (changedValue) {
                    _checkBoxController.sink.add(changedValue!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
