import 'package:flutter/material.dart';
import '../../routing/route_manager.dart';
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
          DrawerItem('Collections', Icons.collections, RouteManager.collections),
          DrawerItem('Create', Icons.create, RouteManager.create),
          DrawerItem('Profile', Icons.account_circle_outlined, RouteManager.profile),
          DrawerItem('Wallet', Icons.account_balance_wallet_outlined, RouteManager.wallet),
        ],
      ),
    );
  }
}
