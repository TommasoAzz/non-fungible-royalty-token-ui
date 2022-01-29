import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/Collections/collection_item.dart';
import '../../locator.dart';

class CollectionsContent extends StatelessWidget {
  const CollectionsContent({Key? key, required this.column, required this.padding})
      : super(key: key);
  final int column;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    return Column(
      children: [
        const PageTitle(title: "collections"),
        const SizedBox(height: 20),
        Expanded(
          child: FutureBuilder<List<Collection>>(
            future: marketplaceVM.getCollections(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (snapshot.data!.isEmpty) {
                return const Text("There are no collections.");
              }

              return GridView.count(
                primary: false,
                padding: EdgeInsets.all(padding),
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                crossAxisCount: column,
                children: snapshot.data!
                    .map((collection) => CollectionItem(
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
