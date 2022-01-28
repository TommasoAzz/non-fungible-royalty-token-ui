import 'package:flutter/material.dart';
import 'collections_content.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CollectionsView extends StatelessWidget {
  const CollectionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const CollectionsContent(
        column: 1,
        padding: 10,
      ),
      tablet: const CollectionsContent(column: 2, padding: 30),
      desktop: const CollectionsContent(column: 3, padding: 30),
    );
  }
}
