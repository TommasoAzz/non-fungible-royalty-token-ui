import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/routing/route_manager.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/services/navigation_service.dart';
import 'views/layout_template/layout_template.dart';

import 'locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      builder: (context, child) => LayoutTemplate(
        child: child!,
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: RouteManager.generateRoute,
      initialRoute: RouteManager.home,
    );
  }
}
