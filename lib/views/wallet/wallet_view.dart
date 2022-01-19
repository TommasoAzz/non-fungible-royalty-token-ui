import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/token/token_view.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(children: [
        Text(
          "Address ${snapshot.data}",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ]);
    });
  }
}
