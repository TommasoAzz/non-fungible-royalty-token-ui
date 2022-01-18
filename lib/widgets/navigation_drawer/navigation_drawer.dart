import 'package:flutter/material.dart';
import '../../routing/router.dart' as router;
import 'drawer_item.dart';
import 'navigation_drawer_header.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: const <Widget>[
          NavigationDrawerHeader(),
          DrawerItem('Collections', Icons.collections, router.CollectionsRoute),
          DrawerItem('Create', Icons.create, router.CreateRoute),
          DrawerItem('Profile', Icons.account_circle_outlined, router.ProfileRoute),
          DrawerItem('Wallet', Icons.account_balance_wallet_outlined, router.WalletRoute),
        ],
      ),
    );
  }
}
