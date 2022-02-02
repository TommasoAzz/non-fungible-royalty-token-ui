import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/models/token.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/token_item/token_item.dart';

class CollectionContent extends StatelessWidget {
  final int column;
  final double padding;

  const CollectionContent({
    Key? key,
    required this.column,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    final collectionData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    late Future<Collection> futureCollection;
    if (collectionData['collection'] != null) {
      futureCollection = Future.value(Collection.fromMap(collectionData['collection']));
    } else if (collectionData['collection_address'] != null) {
      futureCollection = marketplaceVM.getCollection(collectionData['collection_address']);
    } else {
      return const SelectableText("Error loading the collection.");
    }

    return FutureBuilder<Collection>(
        future: futureCollection,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final collection = snapshot.data!;

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
                      return SelectableText("Error: ${snapshot.error}");
                    }

                    if (snapshot.data!.isEmpty) {
                      return const SelectableText("There are no tokens for collection.");
                    }

                    return GridView.count(
                      childAspectRatio: 0.8,
                      primary: false,
                      padding: EdgeInsets.all(padding),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      crossAxisCount: column,
                      children: snapshot.data!
                          .map((token) => TokenItem(
                                isCreativeOwner: token.creativeOwner.toLowerCase() ==
                                    marketplaceVM.loggedAccount,
                                isOwner: token.owner.toLowerCase() == marketplaceVM.loggedAccount,
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
        });
  }
}
