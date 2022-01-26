import 'package:flutter/material.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../services/navigation_service.dart';
import '../../locator.dart';
import '../../widgets/centered_view/centered_view.dart';
import '../../widgets/navigation_bar/navigation_bar.dart' as nbar;
import '../../widgets/navigation_drawer/navigation_drawer.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;
  const LayoutTemplate({Key? key, required this.child}) : super(key: key);

  Future<void> loadDependenciesAndConnectToWallet() async {
    await locator.allReady();
    await locator<MarketplaceVM>().connectToWallet();
  }

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
              FutureBuilder<void>(
                future: loadDependenciesAndConnectToWallet(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Column(
                      children: const [
                        Text(
                          "ERC1190 Marketplace can only be used by logging in with your wallet.",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      "Error while connecting to the wallet: ${snapshot.error}",
                      textAlign: TextAlign.center,
                    );
                  }

                  return Expanded(
                    child: child,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
