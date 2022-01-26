import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/views/home/home_view.dart';
import 'routing/route_manager.dart';
import 'services/navigation_service.dart';
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
      restorationScopeId: "ERC1190Marketplace",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: RouteManager.generateRoute,
      initialRoute: RouteManager.home,
    );
  }
}
