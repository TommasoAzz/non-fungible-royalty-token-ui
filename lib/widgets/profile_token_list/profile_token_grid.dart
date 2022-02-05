import 'package:flutter/material.dart';
import '../../business_logic/models/token.dart';
import '../horizontal_token_list/token_grid.dart';

class ProfileTokenGrid extends StatelessWidget {
  final int column;
  final double padding;

  final Future<List<Token>> tokenList;

  const ProfileTokenGrid({
    Key? key,
    required this.tokenList,
    required this.column,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final marketplaceVM = locator<MarketplaceVM>();
    return FutureBuilder<List<Token>>(
      future: tokenList,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return SelectableText("Error: ${snapshot.error}");
        }

        if (snapshot.data!.isEmpty) {
          return const SelectableText("There are no tokens.");
        }
        return TokenGrid(
          tokens: snapshot.data!,
          column: column,
          padding: padding,
        );
      },
    );
  }
}
