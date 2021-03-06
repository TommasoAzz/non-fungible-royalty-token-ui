import 'package:flutter/material.dart';
import '../../business_logic/models/token.dart';
import '../style_text/style_text.dart';

class TokenInfo extends StatelessWidget {
  final Token token;

  const TokenInfo({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyleText(
          title: "ID: ${token.id}",
        ),
        StyleText(
          title: "Owner: ${token.owner}",
        ),
        StyleText(
          title: "Rented by: ${token.rentedBy.length} people",
        ),
        if (token.ownershipLicensePrice > 0)
          StyleText(
            title: "Ownership license: ${token.ownershipLicensePrice} ETH",
          ),
        if (token.ownershipLicensePrice == 0)
          const StyleText(
            title: "Ownership license: not on sale",
          ),
        if (token.creativeLicensePrice > 0)
          StyleText(
            title: "Creative license: ${token.creativeLicensePrice} ETH",
          ),
        if (token.creativeLicensePrice == 0)
          const StyleText(
            title: "Creative license: not on sale",
          ),
        if (token.rentalPricePerSecond > 0)
          StyleText(
            title: "Rental: ${token.rentalPricePerSecond * 3600} ETH/hour",
          ),
        if (token.rentalPricePerSecond == 0)
          const StyleText(
            title: "Rental: not rentable",
          ),
        StyleText(
          title: "Royalty for ownership transfer: ${token.royaltyOwnershipTransfer}%",
        ),
        StyleText(
          title: "Royalty for rental: ${token.royaltyRental}%",
        ),
      ],
    );
  }
}
