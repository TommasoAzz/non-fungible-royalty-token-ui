import 'package:flutter/material.dart';

class Token extends StatelessWidget {
  const Token({Key? key, required this.text, required this.color})
      : super(key: key);
  final List<String> text;
  final int color;

  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Image.asset('assets/log0.png'),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Collection name: ${text[0]} \n\nSymbol: ${text[1]} \n\nCreator: ${text[2]} \n\nTotal tokens: ${text[3]}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
