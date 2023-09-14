import 'dart:async';

import 'package:cookbook/src/features/theme/bloc/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          color: const Color.fromARGB(255, 199, 199, 199),
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
              color: Colors.white,
            ),
            StreamBuilder(
              stream: _checkBoxStream,
              initialData: false,
              builder: (context, snapshot) {
                return BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    if (state is ThemeLoaded) {
                      return Checkbox(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 199, 199, 199),
                        ),
                        checkColor:
                            state.isDarkTheme ? Colors.green : Colors.white,
                        value: snapshot.data,
                        onChanged: (changedValue) {
                          _checkBoxController.sink.add(changedValue!);
                        },
                      );
                    }
                    return const SizedBox.shrink();
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
