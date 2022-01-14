import 'package:flutter/material.dart';
import '../../routing/route_names.dart';
import '../../widgets/NavigationBar/navbar_logo.dart';
import '../../widgets/NavigationBar/navbar_item.dart';

class NavigationBarTabletDesktop extends StatelessWidget {
  const NavigationBarTabletDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              NavBarItem('Collections', CollectionsRoute),
              SizedBox(
                width: 18,
              ),
              NavBarItem('Create', CreateRoute),
              SizedBox(
                width: 18,
              ),
              NavBarItem('Profile', ProfileRoute),
              SizedBox(
                width: 18,
              ),
              NavBarItem('Wallet', WalletRoute),
            ],
          )
        ],
      ),
    );
  }
}
