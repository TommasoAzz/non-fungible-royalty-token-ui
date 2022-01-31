import 'package:flutter/material.dart';
import '../views/collection/collection_view.dart';
import '../views/error/error_view.dart';
import '../widgets/layout_template/layout_template.dart';
import '../views/create/create_view.dart';
import '../views/collections/collections_view.dart';
import '../views/home/home_view.dart';
import '../views/profile/profile_view.dart';
import '../views/wallet/wallet_view.dart';
import '../extensions/string_extensions.dart';

class RouteManager {
  static const String home = "/";
  static const String create = "/create";
  static const String collections = "/collections";
  static const String profile = "/profile";
  static const String wallet = "/wallet";
  static const String collection = "/collection";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routingData = settings.name!.routingData;
    switch (routingData.route) {
      case home:
        return _FadeRoute(const HomeView(), settings);
      case collections:
        return _FadeRoute(const CollectionsView(), settings);
      case create:
        return _FadeRoute(const CreateView(), settings);
      case profile:
        return _FadeRoute(const ProfileView(), settings);
      case wallet:
        return _FadeRoute(const WalletView(), settings);
      case collection:
        final addr = routingData['addr'];
        final args = {
          'collection':
              settings.arguments != null ? (settings.arguments as Map)['collection'] : null,
          'collection_address': addr ?? (settings.arguments as Map)['collection']['address'],
        };
        return _FadeRoute(
          const CollectionView(),
          RouteSettings(
            name: settings.name,
            arguments: args,
          ),
        );
      default:
        return _FadeRoute(const ErrorView(), settings);
    }
  }
}

class _FadeRoute extends PageRouteBuilder {
  _FadeRoute(final Widget _child, final RouteSettings _settings)
      : super(
          settings: _settings,
          pageBuilder: (context, animation, secondaryAnimation) => LayoutTemplate(child: _child),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
