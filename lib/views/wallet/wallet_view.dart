import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/page_title/page_title.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/token/token_view.dart';
import '../../constants/app_colors.dart';
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: Column(children: <Widget>[
        Token(isOwnershipOwner: true, text: [
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
        ])
      ]),
    );
  }
}

//   @override
//   void initState() {
//     super.initState();
//     connector = locator<Web3Connector>();
//   }

//   Future<String> _connectToWallet() async {
//     if (connector.connectedToWallet) {
//       return connector.firstAccount;
//     }

//     await connector.connectToWallet();

//     return connector.firstAccount;
//   }

//   Future<void> _disconnectFromWallet() async {
//     await connector.disconnectFromWallet();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: FutureBuilder(
//         future: _connectToWallet(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState != ConnectionState.done) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text("Error while connecting to the wallet.\n${snapshot.error}"),
//             );
//           }

//           return Column(
//             children: [
//               const PageTitle(title: "wallet"),
//               Text(
//                 "Connected with account: ${snapshot.data}",
//                 style: const TextStyle(fontSize: 18),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: _disconnectFromWallet,
//                 child: const Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Text(
//                     "Disconnect from wallet",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w800,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   primary: primaryColor,
//                   shape: RoundedRectangleBorder(
//                     side: const BorderSide(color: primaryColor),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
