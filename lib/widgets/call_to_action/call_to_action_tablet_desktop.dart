import 'package:flutter/material.dart';
import '../../business_logic/connector/web3_connector.dart';
import '../../locator.dart';
import '../../../../constants/app_colors.dart';

class CallToActionTabletDesktop extends StatelessWidget {
  final String title;
  // ignore: use_key_in_widget_constructors
  const CallToActionTabletDesktop(this.title);

  @override
  Widget build(BuildContext context) {
    final connector = locator<Web3Connector>();
    return ElevatedButton(
      onPressed: () async {
        if (!connector.connectedToWallet) {
          await connector.connectToWallet();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        child: Text(
          connector.connectedToWallet ? 'Connected to the wallet' : title,
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
