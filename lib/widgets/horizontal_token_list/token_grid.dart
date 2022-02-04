// ignore_for_file: prefer_relative_imports

import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/token_item/token_item.dart';
import '../../business_logic/models/token.dart';

class TokenGrid extends StatelessWidget {
  final List<Token> tokens;
  final bool isCreativeOwner;
  final bool isOwner;

  final int column;
  final double padding;

  const TokenGrid({
    Key? key,
    required this.tokens,
    required this.isCreativeOwner,
    required this.isOwner,
    required this.column,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.65,
      primary: false,
      padding: EdgeInsets.all(padding),
      crossAxisSpacing: 20,
      mainAxisSpacing: 10,
      crossAxisCount: column,
      children: tokens
          .map((token) => TokenItem(
                isCreativeOwner: isCreativeOwner,
                isOwner: isOwner,
                token: token,
                collection: token.collection,
              ))
          .toList(),
    );
  }
}
