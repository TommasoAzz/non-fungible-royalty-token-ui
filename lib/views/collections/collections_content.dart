import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/collection_item/collection_item.dart';
import '../../locator.dart';

class CollectionsContent extends StatefulWidget {
  const CollectionsContent({Key? key, required this.column, required this.padding})
      : super(key: key);
  final int column;
  final double padding;

  @override
  State<CollectionsContent> createState() => _CollectionsContentState();
}

class _CollectionsContentState extends State<CollectionsContent> {
  final marketplaceVM = locator<MarketplaceVM>();

  @override
  void initState() {
    super.initState();
    marketplaceVM.addListener(update);
  }

  @override
  void dispose() {
    marketplaceVM.removeListener(update);
    super.dispose();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

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
                return SelectableText("Error: ${snapshot.error}");
              }

              if (snapshot.data!.isEmpty) {
                return const SelectableText("There are no collections.");
              }

              return GridView.count(
                primary: false,
                padding: EdgeInsets.all(widget.padding),
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                crossAxisCount: widget.column,
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
