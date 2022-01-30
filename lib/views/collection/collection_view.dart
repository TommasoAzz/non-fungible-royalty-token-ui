import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'collection_content.dart';

class CollectionView extends StatelessWidget {
  const CollectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const CollectionContent(
        column: 1,
        padding: 10,
      ),
      tablet: const CollectionContent(column: 2, padding: 30),
      desktop: const CollectionContent(column: 3, padding: 30),
    );
  }
}
