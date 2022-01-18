import 'package:flutter/material.dart';
import '../list_view/list_view.dart';

class ProfileListView extends StatelessWidget {
  final String title;

  const ProfileListView({Key? key, required this.title}) : super(key: key);

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
          child: ListsView(
            entries: [
              'A',
              'B',
              'C',
              'C',
              'C',
              'C',
              'C',
              'C',
              'C',
              'C',
              'C',
              'C'
            ],
            colorCodes: [
              100,
              200,
              300,
              100,
              200,
              300,
              100,
              200,
              300,
              100,
              200,
              300
            ],
          ),
        )
      ],
    );
  }
}
