import 'package:flutter/material.dart';

class StyleText extends StatelessWidget {
  final String title;

  const StyleText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      title,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w200,
      ),
    );
  }
}
