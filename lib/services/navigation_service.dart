import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<dynamic> navigateTo(
    String routeName, [
    Map<String, dynamic> arguments = const {},
  ]) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void goBack() {
    return navigatorKey.currentState?.pop();
  }

  void openDrawer() {
    if (scaffoldKey.currentState?.isDrawerOpen != true) {
      scaffoldKey.currentState?.openDrawer();
    }
  }

  void closeDrawer() {
    if (scaffoldKey.currentState?.isDrawerOpen == true) {
      print("chiudo drawer");
      scaffoldKey.currentState?.openEndDrawer();
    }
  }
}
