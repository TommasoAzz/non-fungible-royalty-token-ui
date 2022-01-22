import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/views/collection_page/collection_page.dart';
import '../views/Create/create_view.dart';
import '../views/collections/collections_view.dart';
import 'package:flutter/widgets.dart';
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('generateRoute: ${settings.name}');
    switch (settings.name) {
      case home:
        return _getPageRoute(const HomeView(), settings);
      case collections:
        return _getPageRoute(const CollectionsView(), settings);
      case collection:
        return _getPageRoute(const CollectionPage(), settings);
      case create:
        return _getPageRoute(const CreateView(), settings);
      case profile:
        return _getPageRoute(const ProfileView(), settings);
      case wallet:
        return _getPageRoute(const WalletView(), settings);
      default:
        return _getPageRoute(const HomeView(), settings);
    }
  }

  static PageRoute _getPageRoute(Widget child, RouteSettings settings) {
    return _FadeRoute(child: child, routeName: settings.name!);
  }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
