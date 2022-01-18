import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/tokenn/token_view.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          Token(text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 100),
          Token(text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 100),
        ],
      ),
    );
  }
}
