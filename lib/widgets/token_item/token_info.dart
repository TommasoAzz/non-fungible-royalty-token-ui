import 'package:flutter/material.dart';
import '../../business_logic/models/token.dart';
import '../style_text/style_text.dart';

class TokenInfo extends StatelessWidget {
  final Token token;
  final bool showOwnershipRequests;
  final bool showCreativeOwnershipRequests;

  const TokenInfo({
    Key? key,
    required this.token,
    required this.showCreativeOwnershipRequests,
    required this.showOwnershipRequests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyleText(title: "ID: ${token.id}"),
        StyleText(title: "Owner: ${token.owner}"),
        StyleText(title: "Rented by: ${token.rentedBy.length} people"),
        StyleText(title: "Ownership license: ${token.ownershipLicensePrice} ETH"),
        StyleText(title: "Creative license: ${token.creativeLicensePrice} ETH"),
        StyleText(title: "Rental: ${token.rentalPricePerSecond} ETH/sec"),
        StyleText(title: "Royalty for ownership transfer: ${token.royaltyOwnershipTransfer}%"),
        StyleText(title: "Royalty for rental: ${token.royaltyRental}%"),
        // if (showOwnershipRequests && token.ownershipLicenseRequests.isNotEmpty)
        //   StyleText(title: "Ownership requests from: ${token.ownershipLicenseRequests}"),
        // if (showOwnershipRequests && token.ownershipLicenseRequests.isEmpty)
        //   const StyleText(title: "No ownership requests available."),
        // if (showCreativeOwnershipRequests && token.ownershipLicenseRequests.isNotEmpty)
        //   StyleText(title: "Creative requests from: ${token.creativeLicenseRequests}"),
        // if (showCreativeOwnershipRequests && token.ownershipLicenseRequests.isEmpty)
        //   const StyleText(title: "No creative ownership requests available."),
      ],
    );
  }
}
