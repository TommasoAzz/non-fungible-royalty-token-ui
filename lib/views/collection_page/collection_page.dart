import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/collection.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/token.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/viewmodel/marketplace_vm.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/locator.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/page_title/page_title.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/token_item/token_item.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    final collectionData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final name = collectionData['collectionName'] as String;
    final address = collectionData['collectionAddress'] as String;

    return Column(
      children: [
        PageTitle(title: name),
        const SizedBox(height: 20),
        FutureBuilder<List<Token>>(
          future: marketplaceVM.getTokens(address),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            if (snapshot.data!.isEmpty) {
              return const Text("There are no tokens for collection.");
            }

            return GridView.count(
              primary: false,
              // padding: EdgeInsets.all(padding),
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: snapshot.data!
                  .map((token) => TokenItem(
                        isCreativeOwner: token.creativeOwner == marketplaceVM.loggedAccount,
                        isOwner: token.owner == marketplaceVM.loggedAccount,
                        token: token,
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
