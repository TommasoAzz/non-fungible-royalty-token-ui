import 'package:flutter/material.dart';
import '../logger/logger.dart';

class NavigationService {
  final _logger = getLogger("NavigationService");

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<dynamic> navigateTo(
    String routeName, [
    Map<String, dynamic> arguments = const {},
  ]) {
    _logger.v("navigateTo: $routeName");

    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void goBack() {
    _logger.v("goBack");

    return navigatorKey.currentState?.pop();
  }

  void openDrawer() {
    _logger.v("openDrawer");

    if (scaffoldKey.currentState?.isDrawerOpen != true) {
      scaffoldKey.currentState?.openDrawer();
    }
  }

  void closeDrawer() {
    _logger.v("closeDrawer");

    if (scaffoldKey.currentState?.isDrawerOpen == true) {
      scaffoldKey.currentState?.openEndDrawer();
    }
  }
}
