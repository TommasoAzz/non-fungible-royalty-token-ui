import 'package:flutter/material.dart';
import '../../routing/route_manager.dart';
import '../../services/navigation_service.dart';
import '../../widgets/page_title/page_title.dart';
import '../../locator.dart';
import '../../widgets/collections/collection.dart';

class CollectionsContentTabletDesktop extends StatelessWidget {
  const CollectionsContentTabletDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageTitle(title: "collections"),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: collections
                .map(
                  (collection) => InkWell(
                    onTap: () => locator<NavigationService>().navigateTo(RouteManager.collection, {
                      'collection': collection,
                    }),
                    child: Container(
                      child: Text(
                        "${collection.nameCollection}\n${collection.symbol}\n${collection.creator}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[collection.tokenNumber * 100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
