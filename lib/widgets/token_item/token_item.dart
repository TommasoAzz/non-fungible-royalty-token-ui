import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/token.dart';
import '../../widgets/style_text/style_text.dart';
import '../../widgets/form_field/form_field.dart' as form;

class TokenItem extends StatelessWidget {
  TokenItem({
    Key? key,
    required this.isCreativeOwner,
    required this.isOwner,
    required this.token,
  }) : super(key: key);

  final Token token;

  final bool isCreativeOwner;
  final bool isOwner;

  double _ownershipLicensePrice = 0;
  double _rentalPricePerSecond = 0;
  double _creativeLicensePrice = 0;
  String _transferOwnershipLicenseTo = '';
  String _transferCreativeLicenseTo = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: secondaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/ape.png'),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                height: 200,
                width: 400,
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
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
                      StyleText(
                        title: "Ownership license price: ${token.ownershipLicensePrice} ETH",
                      ),
                      StyleText(
                        title: "Creative license price: ${token.creativeLicensePrice} ETH",
                      ),
                      StyleText(
                        title: "Rental price: ${token.rentalPricePerSecond} ETH/second",
                      ),
                      StyleText(
                        title: "Royalty for ownership transfer: ${token.royaltyOwnershipTransfer}",
                      ),
                      StyleText(
                        title: "Royalty for rental: ${token.royaltyRental}",
                      ),
                      if (isOwner)
                        StyleText(
                          title: "Ownership requests from: ${token.ownershipLicenseRequests}",
                        ),
                      if (isCreativeOwner)
                        StyleText(
                          title: "Creative requests from: ${token.creativeLicenseRequests}",
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isOwner)
            SizedBox(
              width: 500,
              child: form.FormField(
                inputLabel: "Set Ownership License price",
                validationCallback: _validateNumberField,
                onSavedCallback: _saveOwnershipLicensePriceInputField,
              ),
            ),
          if (isOwner)
            SizedBox(
              width: 500,
              child: form.FormField(
                inputLabel: "Set Rental price per second",
                validationCallback: _validateNumberField,
                onSavedCallback: _saveRentalPricePerSecondInputField,
              ),
            ),
          if (isOwner)
            SizedBox(
              width: 500,
              child: form.FormField(
                inputLabel: "Transfer Ownership License to",
                validationCallback: _validateAddressField,
                onSavedCallback: _saveTransferOwnershipLicenseInputField,
              ),
            ),
          if (isCreativeOwner)
            SizedBox(
                width: 500,
                child: form.FormField(
                  inputLabel: "Set Creative License price",
                  validationCallback: _validateNumberField,
                  onSavedCallback: _saveCreativeLicensePriceInputField,
                )),
          if (isCreativeOwner)
            SizedBox(
                width: 500,
                child: form.FormField(
                  inputLabel: "Transfer Creative License to",
                  validationCallback: _validateAddressField,
                  onSavedCallback: _saveTransferCreativeLicenseInputField,
                )),
        ],
      ),
    );
  }

  void _saveOwnershipLicensePriceInputField(final String? number) =>
      _ownershipLicensePrice = double.tryParse(number ?? '') ?? 0;

  void _saveCreativeLicensePriceInputField(final String? number) =>
      _creativeLicensePrice = double.tryParse(number ?? '') ?? 0;

  void _saveRentalPricePerSecondInputField(final String? number) =>
      _rentalPricePerSecond = double.tryParse(number ?? '') ?? 0;

  void _saveTransferOwnershipLicenseInputField(final String? name) =>
      _transferOwnershipLicenseTo = name ?? '';

  void _saveTransferCreativeLicenseInputField(final String? name) =>
      _transferCreativeLicenseTo = name ?? '';

  String? _validateAddressField(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    } else if (value.length != 42 && value[0] != '0' && value[1] != 'x') {
      return 'Please enter a valide address ';
    }
    return null;
  }

  String? _validateNumberField(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    } else if (double.tryParse(value) != null && double.tryParse(value)! < 0) {
      return 'Please enter a positive value ';
    }
    return null;
  }
}
