import 'package:flutter/material.dart';
import '../../routing/route_manager.dart';
import '../../services/navigation_service.dart';

import '../../locator.dart';

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<NavigationService>().navigateTo(RouteManager.home);
      },
      child: const Text(
        "ERC1190\nMARKETPLACE",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
