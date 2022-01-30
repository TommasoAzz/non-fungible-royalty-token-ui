import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/views/collection_page/collection_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CollectionsPageView extends StatelessWidget {
  const CollectionsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const CollectionPage(
        column: 1,
        padding: 10,
      ),
      tablet: const CollectionPage(column: 2, padding: 30),
      desktop: const CollectionPage(column: 3, padding: 30),
    );
  }
}
