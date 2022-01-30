import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/models/token.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/token_item/token_item.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key, required this.column, required this.padding})
      : super(key: key);
  final int column;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    final collectionData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final collection = Collection.fromMap(collectionData['collection']);

    return Column(
      children: [
        PageTitle(title: collection.name),
        const SizedBox(height: 20),
        Expanded(
          child: FutureBuilder<List<Token>>(
            future: marketplaceVM.getTokens(collection.address),
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
                padding: EdgeInsets.all(padding),
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                crossAxisCount: column,
                children: snapshot.data!
                    .map((token) => TokenItem(
                          isCreativeOwner: token.creativeOwner ==
                              marketplaceVM.loggedAccount,
                          isOwner: token.owner == marketplaceVM.loggedAccount,
                          token: token,
                          collection: collection,
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
