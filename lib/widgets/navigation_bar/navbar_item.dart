import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final String navigationPath;

  const NavBarItem(this.title, this.navigationPath);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Scaffold.of(context).hasDrawer) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).restorablePushNamed(navigationPath);
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
