import 'package:flutter/material.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../routing/route_manager.dart';
import '../../services/navigation_service.dart';
import '../../widgets/page_title/page_title.dart';
import '../../locator.dart';

class CollectionsContent extends StatelessWidget {
  const CollectionsContent({Key? key, required this.column, required this.padding})
      : super(key: key);
  final int column;
  final double padding;

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

              if (snapshot.data!.isEmpty) {
                return const Text("There are no collections.");
              }

              return GridView.count(
                primary: false,
                padding: EdgeInsets.all(padding),
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                crossAxisCount: column,
                children: snapshot.data!
                    .map(
                      (collection) => InkWell(
                        onTap: () => Navigator.of(context).restorablePushNamed(
                          RouteManager.collection,
                          arguments: {
                            'collection': "${collection.name}-${collection.symbol}".toLowerCase(),
                          },
                        ),
                        child: Card(
                          color: Colors.blue[collection.availableTokens * 100],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Text(
                                  collection.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Symbol: ${collection.symbol}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Created by\n${collection.creator}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
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
