import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/Token/token_view.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Token(
          text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 100),
    );
  }
}
