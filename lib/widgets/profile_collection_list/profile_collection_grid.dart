import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../horizontal_collection_list/collection_grid.dart';

class ProfileCollectionGrid extends StatelessWidget {
  final int column;
  final double padding;

  const ProfileCollectionGrid({
    Key? key,
    required this.column,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    return FutureBuilder<List<Collection>>(
      future: marketplaceVM.getCollections(marketplaceVM.loggedAccount),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return SelectableText("Error: ${snapshot.error}");
        }

        if (snapshot.data!.isEmpty) {
          return const SelectableText("There are no collections.");
        }
        return CollectionGrid(
          collections: snapshot.data!,
          column: column,
          padding: padding,
        );
      },
    );
  }
}
