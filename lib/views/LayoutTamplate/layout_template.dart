import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../routing/route_names.dart';
import '../../routing/router.dart';
import '../../services/navigation_service.dart';
import '../../widgets/CenteredView/centered_view.dart';
import '../../widgets/NavigationBar/navigation_bar.dart' as nbar;
import '../../widgets/NavigationDrawer/navigation_drawer.dart';

import '../../locator.dart';

class LayoutTemplate extends StatelessWidget {
  const LayoutTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.isMobile ? NavigationDrawer() : null,
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              nbar.NavigationBar(),
              Expanded(
                child: Navigator(
                  key: locator<NavigationService>().navigatorKey,
                  onGenerateRoute: generateRoute,
                  initialRoute: HomeRoute,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
