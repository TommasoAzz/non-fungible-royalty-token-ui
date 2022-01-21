import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/views/collection_page/collection_page.dart';
import '../views/Create/create_view.dart';
import '../views/collections/collections_view.dart';

import '../views/home/home_view.dart';
import '../views/profile/profile_view.dart';
import '../views/wallet/wallet_view.dart';

class RouteManager {
  static const String home = "/home";
  static const String create = "/create";
  static const String collections = "/collections";
  static const String profile = "/profile";
  static const String wallet = "/wallet";
  static const String collection = "/collection";

  static PageRoute generateRoute(RouteSettings settings) {
    print('generateRoute: ${settings.name}');
    switch (settings.name) {
      case home:
        return _getPageRoute(const HomeView());
      case collections:
        return _getPageRoute(const CollectionsView());
      case collection:
        return _getPageRoute(const CollectionPage());
      case create:
        return _getPageRoute(const CreateView());
      case profile:
        return _getPageRoute(const ProfileView());
      case wallet:
        return _getPageRoute(const WalletView());
      default:
        return _getPageRoute(const HomeView());
    }
  }

  static PageRoute _getPageRoute(Widget child) {
    return MaterialPageRoute(
      builder: (context) => child,
    );
  }
}
