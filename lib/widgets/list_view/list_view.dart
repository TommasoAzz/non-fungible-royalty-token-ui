import 'package:flutter/material.dart';
import '../../widgets/collections/collections.dart';

final List<int> colorCodes = <int>[600, 500, 100];

class ListsView extends StatelessWidget {
  const ListsView({Key? key, required this.entries, required this.colorCodes}) : super(key: key);
  final List<String> entries;
  final List<int> colorCodes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return const Collection(text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 100);
      },
    );
  }
}
