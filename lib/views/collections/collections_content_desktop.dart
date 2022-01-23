import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/collection.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/viewmodel/marketplace_vm.dart';
import '../../routing/route_manager.dart';
import '../../services/navigation_service.dart';
import '../../widgets/page_title/page_title.dart';
import '../../locator.dart';

class CollectionsContentDesktop extends StatelessWidget {
  const CollectionsContentDesktop({Key? key}) : super(key: key);

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
                return Text("Error: ${snapshot.error}");
              }

              return GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                children: snapshot.data!
                    .map(
                      (collection) => InkWell(
                        onTap: () => locator<NavigationService>().navigateTo(
                          RouteManager.collection,
                          {
                            'collection': collection,
                          },
                        ),
                        child: Container(
                          child: Text(
                            "${collection.name}\n${collection.symbol}\n${collection.creator}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                              color: Colors.black,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[collection.availableTokens * 100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
