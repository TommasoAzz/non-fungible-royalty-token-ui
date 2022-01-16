import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/routing/route_names.dart';
import '../../services/navigation_service.dart';

import '../../locator.dart';

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<NavigationService>().navigateTo(HomeRoute);
      },
      child: Text(
        "ERC1190 \nMARKETPLACE",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
