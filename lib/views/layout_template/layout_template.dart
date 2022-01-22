import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/services/navigation_service.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../locator.dart';
import '../../widgets/centered_view/centered_view.dart';
import '../../widgets/navigation_bar/navigation_bar.dart' as nbar;
import '../../widgets/navigation_drawer/navigation_drawer.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;
  const LayoutTemplate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        key: locator<NavigationService>().scaffoldKey,
        drawer: sizingInformation.isMobile || sizingInformation.isTablet
            ? const NavigationDrawer()
            : null,
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              const nbar.NavigationBar(),
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
