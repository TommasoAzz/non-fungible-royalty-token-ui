import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  const TextBox({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        )
      ],
    );
  }
}
