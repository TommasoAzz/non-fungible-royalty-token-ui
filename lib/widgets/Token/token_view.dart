import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/constants/app_colors.dart';

class Token extends StatelessWidget {
  const Token({Key? key, required this.text, required this.color}) : super(key: key);
  final List<String> text;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/ape.png'),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            height: 200,
            width: 200,
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.start,

              child: Text(
                "Collection name: ${text[0]} \n\nSymbol: ${text[1]} \n\nCreator: ${text[2]} \n\nTotal tokens: ${text[3]} \n\nCollection name: ${text[0]} \n\nSymbol: ${text[1]} \n\nCreator: ${text[2]} \n\nTotal tokens: ${text[3]}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
