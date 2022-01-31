import 'package:flutter/material.dart';
import 'routing/route_manager.dart';

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
      title: 'ERC1190 Marketplace',
      restorationScopeId: "ERC1190Marketplace",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
