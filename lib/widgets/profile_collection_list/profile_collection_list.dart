import 'package:flutter/material.dart';
import '../horizontal_collection_list/horizontal_collection_list.dart';

class ProfileCollectionList extends StatelessWidget {
  final String title;

  const ProfileCollectionList({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          height: 270,
          child: HorizontalCollectionList(
            entries: [],
          ),
        )
      ],
    );
  }
}
