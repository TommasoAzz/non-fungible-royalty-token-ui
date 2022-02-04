// ignore_for_file: prefer_relative_imports

import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/token_item/token_item.dart';
import '../../business_logic/models/token.dart';

class HorizontalTokenList extends StatelessWidget {
  final List<Token> tokens;
  final bool isCreativeOwner;
  final bool isOwner;

  const HorizontalTokenList({
    Key? key,
    required this.tokens,
    required this.isCreativeOwner,
    required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // shrinkWrap: true,
      // physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: tokens.length,
      itemBuilder: (context, index) => TokenItem(
        token: tokens[index],
        collection: tokens[index].collection,
        isCreativeOwner: isCreativeOwner,
        isOwner: isOwner,
      ),
    );
  }
}
