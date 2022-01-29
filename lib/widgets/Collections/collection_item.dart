import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/routing/route_manager.dart';
import '../../business_logic/models/collection.dart';

class CollectionItem extends StatelessWidget {
  const CollectionItem({Key? key, required this.collection}) : super(key: key);

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).restorablePushNamed(
        RouteManager.collection,
        arguments: {
          'collection': collection.address,
        },
      ),
      child: Card(
        color: Colors.blue[collection.availableTokens * 100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: SingleChildScrollView(
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
                "Created by:\n${collection.creator}",
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
    );
  }
}
