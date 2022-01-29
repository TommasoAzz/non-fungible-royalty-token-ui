import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/collection.dart';
import '../../widgets/collections/collectionItem.dart';
import '../../business_logic/models/collection.dart';

class ListsView extends StatelessWidget {
  const ListsView({Key? key, required this.entries}) : super(key: key);
  final List<Collection> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return CollectionItem(
          collection: entries[index],
        );
      },
    );
  }
}
