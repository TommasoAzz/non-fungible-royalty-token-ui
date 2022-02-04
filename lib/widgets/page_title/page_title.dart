import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double fontSize;

  const PageTitle({Key? key, required this.title, this.fontSize = 32.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SelectableText(
        title.toUpperCase(),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
