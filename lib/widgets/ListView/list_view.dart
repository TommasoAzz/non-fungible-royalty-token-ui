import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/Collections/collections.dart';

final List<int> colorCodes = <int>[600, 500, 100];

class ListsView extends StatelessWidget {
  const ListsView({Key? key, required this.entries, required this.colorCodes})
      : super(key: key);
  final List<String> entries;
  final List<int> colorCodes;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
            height: 100,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return const Collection(
                      text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                      color: 100);
                })));
  }
}
