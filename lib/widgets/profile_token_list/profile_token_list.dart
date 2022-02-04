import 'package:flutter/material.dart';
import '../../business_logic/models/token.dart';
import '../horizontal_token_list/horizontal_token_list.dart';

class ProfileTokenList extends StatelessWidget {
  final String title;
  final Future<List<Token>> tokenList;
  final bool isCreativeOwner;
  final bool isOwner;

  const ProfileTokenList({
    Key? key,
    required this.title,
    required this.tokenList,
    required this.isCreativeOwner,
    required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final marketplaceVM = locator<MarketplaceVM>();
    return Column(
      children: [
        SelectableText(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Token>>(
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
            return HorizontalTokenList(
              tokens: snapshot.data!,
              isCreativeOwner: isCreativeOwner,
              isOwner: isOwner,
            );
          },
        ),
      ],
    );
  }
}