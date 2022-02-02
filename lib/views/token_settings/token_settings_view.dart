import 'dart:math';

import 'package:flutter/material.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';
import '../../widgets/token_settings/token_settings_form_field.dart';

class TokenSettingsView extends StatefulWidget {
  final String? Function(String?) validateNumberField;
  final String? Function(String?) validateAddressField;

  final bool isOwner;
  final bool isCreativeOwner;

  final String collectionAddress;
  final int tokenId;

  const TokenSettingsView({
    Key? key,
    required this.validateNumberField,
    required this.validateAddressField,
    required this.isCreativeOwner,
    required this.isOwner,
    required this.collectionAddress,
    required this.tokenId,
  }) : super(key: key);

  @override
  State<TokenSettingsView> createState() => _TokenSettingsViewState();
}

class _TokenSettingsViewState extends State<TokenSettingsView> {
  final vm = locator<MarketplaceVM>();
  double _ownershipLicensePrice = 0;
  double _rentalPricePerSecond = 0;
  double _creativeLicensePrice = 0;
  String _transferOwnershipLicenseTo = '';
  String _transferCreativeLicenseTo = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: TokenSettingsFormField(
              inputLabel: "Set ownership license price (ETH)",
              save: (number) => setState(() {
                _ownershipLicensePrice = double.tryParse(number ?? '') ?? 0;
              }),
              validate: widget.validateNumberField,
              successDescription: "Ownership license price updated successfully.",
              updateToken: () async => await vm.setOwnershipLicensePrice(
                widget.collectionAddress,
                widget.tokenId,
                _ownershipLicensePrice,
              ),
            ),
          ),
        if (widget.isOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: TokenSettingsFormField(
              inputLabel: "Set rental price (ETH/second)",
              save: (number) => setState(() {
                _rentalPricePerSecond = double.tryParse(number ?? '') ?? 0;
              }),
              validate: widget.validateNumberField,
              successDescription: "Rental price per second updated successfully.",
              updateToken: () async => await vm.setRentalPrice(
                widget.collectionAddress,
                widget.tokenId,
                _rentalPricePerSecond,
              ),
            ),
          ),
        if (widget.isOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: TokenSettingsFormField(
              inputLabel: "Transfer ownership license",
              save: (address) => setState(() {
                _transferOwnershipLicenseTo = address ?? '';
              }),
              validate: widget.validateAddressField,
              successDescription: "Ownership license transferred successfully.",
              updateToken: () async => await vm.transferOwnershipLicense(
                widget.collectionAddress,
                widget.tokenId,
                _transferOwnershipLicenseTo,
              ),
            ),
          ),
        if (widget.isCreativeOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: TokenSettingsFormField(
              inputLabel: "Set creative license price (ETH)",
              save: (number) => setState(() {
                _creativeLicensePrice = double.tryParse(number ?? '') ?? 0;
              }),
              validate: widget.validateNumberField,
              successDescription: "Creative license price updated successfully.",
              updateToken: () async => await vm.setCreativeLicensePrice(
                widget.collectionAddress,
                widget.tokenId,
                _creativeLicensePrice,
              ),
            ),
          ),
        if (widget.isCreativeOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: TokenSettingsFormField(
              inputLabel: "Transfer creative license",
              save: (address) => setState(() {
                _transferCreativeLicenseTo = address ?? '';
              }),
              validate: widget.validateAddressField,
              successDescription: "Creative license transferred successfully.",
              updateToken: () async => await vm.transferCreativeLicense(
                widget.collectionAddress,
                widget.tokenId,
                _transferCreativeLicenseTo,
              ),
            ),
          ),
      ],
    );
  }
}
