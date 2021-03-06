import 'package:flutter/material.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../widgets/page_title/page_title.dart';
import '../../locator.dart';

class WalletView extends StatefulWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final vm = locator<MarketplaceVM>();

  @override
  void initState() {
    super.initState();
    vm.addListener(update);
  }

  @override
  void dispose() {
    vm.removeListener(update);
    super.dispose();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _connectToWallet() async {
    try {
      await vm.connectToWallet();
    } on Exception catch (exc) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const SelectableText("Error while connecting to the wallet"),
          content: SelectableText(exc.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = vm.isConnected;
    return SingleChildScrollView(
      child: Column(
        children: [
          const PageTitle(title: "wallet"),
          if (isConnected)
            SelectableText(
              "Connected with account: ${vm.loggedAccount}",
              style: const TextStyle(fontSize: 20),
            ),
          if (!isConnected)
            ElevatedButton(
              onPressed: _connectToWallet,
              child: const SelectableText("Connect to wallet"),
            ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
