import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
      ),
    );
  }
}
