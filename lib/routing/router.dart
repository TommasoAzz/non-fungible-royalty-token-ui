import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../routing/route_names.dart';
import '../views/Create/create_view.dart';
import '../views/collections/collections_view.dart';

import '../views/home/home_view.dart';
import '../views/profile/profile_view.dart';
import '../views/wallet/wallet_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  print('generateRoute: ${settings.name}');
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(HomeView());
    case CollectionsRoute:
      return _getPageRoute(CollectionsView());
    case CreateRoute:
      return _getPageRoute(CreateView());
    case ProfileRoute:
      return _getPageRoute(ProfileView());
    case WalletRoute:
      return _getPageRoute(WalletView());
    default:
      return _getPageRoute(HomeView());
  }
}

PageRoute _getPageRoute(Widget child) {
  return _FadeRoute(
    child: child,
  );
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  _FadeRoute({required this.child})
      : super(
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
