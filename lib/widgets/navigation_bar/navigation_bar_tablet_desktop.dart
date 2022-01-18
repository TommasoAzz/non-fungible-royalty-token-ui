import 'package:flutter/material.dart';
import '../../routing/router.dart' as router;
import '../../widgets/navigation_bar/navbar_logo.dart';
import '../../widgets/navigation_bar/navbar_item.dart';

class NavigationBarTabletDesktop extends StatelessWidget {
  const NavigationBarTabletDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const NavBarLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              NavBarItem('Collections', router.CollectionsRoute),
              SizedBox(
                width: 18,
              ),
              NavBarItem('Create', router.CreateRoute),
              SizedBox(
                width: 18,
              ),
              NavBarItem('Profile', router.ProfileRoute),
              SizedBox(
                width: 18,
              ),
              NavBarItem('Wallet', router.WalletRoute),
            ],
          ),
        ],
      ),
    );
  }
}
