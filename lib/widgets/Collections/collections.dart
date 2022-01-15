import 'package:flutter/material.dart';

class Collection extends StatelessWidget {
  const Collection({Key? key, required this.text, required this.color})
      : super(key: key);
  final List<String> text;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.all(5),
      alignment: Alignment.center,
      child: SingleChildScrollView(
          child: Text(
        "Collection name: ${text[0]} \n\nSymbol: ${text[1]} \n\nCreator: ${text[2]} \n\nTotal tokens: ${text[3]}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w200,
          color: Colors.black,
        ),
      )),
      decoration: BoxDecoration(
        color: Colors.blue[color],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
