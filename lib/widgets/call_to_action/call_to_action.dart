import 'package:flutter/material.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../../../../constants/app_colors.dart';

class CallToAction extends StatefulWidget {
  final String title;
  // ignore: use_key_in_widget_constructors
  const CallToAction(this.title);

  @override
  State<CallToAction> createState() => _CallToActionState();
}

class _CallToActionState extends State<CallToAction> {
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!vm.isConnected) {
          await vm.connectToWallet();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          vm.isConnected ? 'Connected to the wallet' : widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
