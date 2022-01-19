import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/views/collections/collection_content_tablet.dart';
import 'collections_content_mobile.dart';
import 'collections_content_tablet_desktop.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CollectionsView extends StatelessWidget {
  const CollectionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const CollectionsContentMobile(),
      tablet: const CollectionsContentTablet(),
      desktop: const CollectionsContentTabletDesktop(),
    );
  }
}
