import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../collection_item/collection_item.dart';

class HorizontalCollectionList extends StatelessWidget {
  final List<Collection> entries;

  const HorizontalCollectionList({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // shrinkWrap: true,
      // physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: entries.length,
      itemBuilder: (context, index) => CollectionItem(
        collection: entries[index],
      ),
    );
  }
}
