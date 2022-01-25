import 'package:flutter/material.dart';
import '../../widgets/page_title/page_title.dart';
import '../../business_logic/connector/web3_connector.dart';
import '../../locator.dart';

class WalletView extends StatefulWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  late Web3Connector connector;

  @override
  void initState() {
    super.initState();
    connector = locator<Web3Connector>();
    connector.addListener(() => setState(() {}));
  }

  Future<String> _connectToWallet() async {
    if (connector.connectedToWallet) {
      return connector.firstAccount;
    }

    await connector.connectToWallet();

    return connector.firstAccount;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: _connectToWallet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Error while connecting to the wallet.\n${snapshot.error}"),
            );
          }

          return Column(
            children: [
              const PageTitle(title: "wallet"),
              Text(
                "Connected with account: ${snapshot.data}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}
