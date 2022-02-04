import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../collection_item/collection_item.dart';

class CollectionGrid extends StatelessWidget {
  final List<Collection> collections;

  final int column;
  final double padding;

  const CollectionGrid({
    Key? key,
    required this.collections,
    required this.column,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: EdgeInsets.all(padding),
      crossAxisSpacing: 20,
      mainAxisSpacing: 10,
      crossAxisCount: column,
      children: collections
          .map((collection) => CollectionItem(
                collection: collection,
              ))
          .toList(),
    );
  }
}
