import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../horizontal_collection_list/horizontal_collection_list.dart';

class ProfileCollectionList extends StatelessWidget {
  final String title;

  const ProfileCollectionList({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketplaceVM = locator<MarketplaceVM>();
    return Column(
      children: [
        SelectableText(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Collection>>(
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
            return HorizontalCollectionList(
              entries: snapshot.data!,
            );
          },
        ),
      ],
    );
  }
}
