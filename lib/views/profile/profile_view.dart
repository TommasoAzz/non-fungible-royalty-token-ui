import 'package:flutter/material.dart';
import '../../widgets/ListView/list_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          Text(
            "My Profile",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            "Created",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 270,
            child: ListsView(
              entries: ['A', 'B', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C'],
              colorCodes: [100, 200, 300, 100, 200, 300, 100, 200, 300, 100, 200, 300],
            ),
          ),
          Text(
            "Owned",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 270,
            child: ListsView(entries: ['A', 'F', 'D'], colorCodes: [100, 200, 300]),
          ),
          Text(
            "Created",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 270,
            child: ListsView(
              entries: ['A', 'B', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C'],
              colorCodes: [100, 200, 300, 100, 200, 300, 100, 200, 300, 100, 200, 300],
            ),
          ),
          Text(
            "Created",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 270,
            child: ListsView(
              entries: ['A', 'B', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C'],
              colorCodes: [100, 200, 300, 100, 200, 300, 100, 200, 300, 100, 200, 300],
            ),
          ),
        ],
      ),
    );
  }
}
