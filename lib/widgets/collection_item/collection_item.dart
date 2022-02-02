import 'package:flutter/material.dart';
import '../../routing/route_manager.dart';
import '../../business_logic/models/collection.dart';

class CollectionItem extends StatelessWidget {
  final Collection collection;

  const CollectionItem({Key? key, required this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).restorablePushNamed(
          Uri(
            path: RouteManager.collection,
            queryParameters: {'addr': collection.address},
          ).toString(),
          arguments: {
            'collection': collection.toMap(),
          },
        );
      },
      child: Card(
        color: Colors.blue[collection.availableTokens * 100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 8,
              ),
              SelectableText(
                "${collection.name} (${collection.symbol})".toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              SelectableText(
                "Created by:\n${collection.creator}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SelectableText(
                "${collection.availableTokens} tokens",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
