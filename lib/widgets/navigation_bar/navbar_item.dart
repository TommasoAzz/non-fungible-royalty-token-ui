import 'package:flutter/material.dart';
import '../../services/navigation_service.dart';

import '../../locator.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final String navigationPath;

  const NavBarItem(this.title, this.navigationPath);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final navService = locator<NavigationService>();
        if (Scaffold.of(context).hasDrawer) {
          navService.closeDrawer();
        }
        navService.navigateTo(navigationPath);
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
