import 'package:flutter/material.dart';
import '../../widgets/ListView/list_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text(
            "My Profile",
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            "Created",
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          ListsView(
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
          Text(
            "Owned",
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          ListsView(entries: ['A', 'F', 'D'], colorCodes: [100, 200, 300])
        ],
      ),
    );
  }
}
