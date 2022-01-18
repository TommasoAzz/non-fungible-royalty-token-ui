import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../routing/router.dart' as router;
import '../../services/navigation_service.dart';
import '../../widgets/centered_view/centered_view.dart';
import '../../widgets/navigation_bar/navigation_bar.dart' as nbar;
import '../../widgets/navigation_drawer/navigation_drawer.dart';

import '../../locator.dart';

class LayoutTemplate extends StatelessWidget {
  const LayoutTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.isMobile ? const NavigationDrawer() : null,
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              const nbar.NavigationBar(),
              Expanded(
                child: Navigator(
                  key: locator<NavigationService>().navigatorKey,
                  onGenerateRoute: router.generateRoute,
                  initialRoute: router.HomeRoute,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}