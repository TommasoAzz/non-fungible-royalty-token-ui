import 'package:flutter/material.dart';
import '../views/Create/create_view.dart';
import '../views/collections/collections_view.dart';

import '../views/home/home_view.dart';
import '../views/profile/profile_view.dart';
import '../views/wallet/wallet_view.dart';

// ignore: constant_identifier_names
const String HomeRoute = "home";
// ignore: constant_identifier_names
const String CreateRoute = "create";
// ignore: constant_identifier_names
const String CollectionsRoute = "collections";
// ignore: constant_identifier_names
const String ProfileRoute = "profile";
// ignore: constant_identifier_names
const String WalletRoute = "wallet";

Route<dynamic> generateRoute(RouteSettings settings) {
  print('generateRoute: ${settings.name}');
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(const HomeView());
    case CollectionsRoute:
      return _getPageRoute(const CollectionsView());
    case CreateRoute:
      return _getPageRoute(const CreateView());
    case ProfileRoute:
      return _getPageRoute(const ProfileView());
    case WalletRoute:
      return _getPageRoute(const WalletView());
    default:
      return _getPageRoute(const HomeView());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}
