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

  final List<String> creativeLicenseRequests;
  final List<String> ownershipLicenseRequests;

  final List<String> expiredRenters;
  final List<String> notExpiredRenters;

  const TokenSettingsView({
    Key? key,
    required this.validateNumberField,
    required this.validateAddressField,
    required this.isCreativeOwner,
    required this.isOwner,
    required this.collectionAddress,
    required this.tokenId,
    required this.creativeLicenseRequests,
    required this.ownershipLicenseRequests,
    this.expiredRenters = const [],
    this.notExpiredRenters = const [],
  }) : super(key: key);

  @override
  State<TokenSettingsView> createState() => _TokenSettingsViewState();
}

class _TokenSettingsViewState extends State<TokenSettingsView> {
  final vm = locator<MarketplaceVM>();
  double _ownershipLicensePrice = 0;
  double _rentalPricePerHour = 0;
  double _creativeLicensePrice = 0;
  String _transferOwnershipLicenseTo = '';
  String _transferCreativeLicenseTo = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
        maxHeight: max(420, MediaQuery.of(context).size.height * 0.8),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.isOwner)
              TokenSettingsFormField(
                inputLabel: "Set ownership license price (ETH)",
                save: (number) => setState(() {
                  _ownershipLicensePrice = double.tryParse(number ?? '') ?? 0;
                }),
                validate: widget.validateNumberField,
                successDescription:
                    "Ownership license price updated successfully.",
                updateToken: () async => await vm.setOwnershipLicensePrice(
                  widget.collectionAddress,
                  widget.tokenId,
                  _ownershipLicensePrice,
                ),
              ),
            if (widget.isOwner)
              TokenSettingsFormField(
                inputLabel: "Set rental price (ETH/hour)",
                save: (number) => setState(() {
                  _rentalPricePerHour = double.tryParse(number ?? '') ?? 0;
                }),
                validate: widget.validateNumberField,
                successDescription: "Rental price updated successfully.",
                updateToken: () async => await vm.setRentalPrice(
                  widget.collectionAddress,
                  widget.tokenId,
                  _rentalPricePerHour / 3600,
                ),
              ),
            if (widget.isOwner && widget.ownershipLicenseRequests.isNotEmpty)
              SizedBox(
                width: max(480, MediaQuery.of(context).size.width * 0.8),
                child: const Text(
                  "Approve ownership license transfer requests",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            if (widget.isOwner && widget.ownershipLicenseRequests.isNotEmpty)
              SizedBox(
                width: max(480, MediaQuery.of(context).size.width * 0.8),
                height: Theme.of(context).buttonTheme.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.ownershipLicenseRequests.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => OutlinedButton(
                    onPressed: () async {
                      await vm.approveOwnership(
                        widget.collectionAddress,
                        widget.tokenId,
                        widget.ownershipLicenseRequests[i],
                      );
                      await vm.removeOwnershipLicenseTransferApproval(
                          widget.collectionAddress,
                          widget.tokenId,
                          widget.ownershipLicenseRequests[i]);
                    },
                    child: Text(widget.ownershipLicenseRequests[i]),
                  ),
                ),
              ),
            if ((widget.isOwner || widget.isCreativeOwner) &&
                widget.expiredRenters.isNotEmpty)
              SizedBox(
                width: max(480, MediaQuery.of(context).size.width * 0.8),
                child: const Text(
                  "Accounts with expired rentals",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            if ((widget.isOwner || widget.isCreativeOwner) &&
                widget.expiredRenters.isNotEmpty)
              SizedBox(
                width: max(480, MediaQuery.of(context).size.width * 0.8),
                height: Theme.of(context).buttonTheme.height,
                child: ListView.builder(
                  itemCount: widget.expiredRenters.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => OutlinedButton(
                    onPressed: () async {
                      await vm.updateEndRentalDate(
                        widget.collectionAddress,
                        widget.tokenId,
                        DateTime.now().millisecondsSinceEpoch,
                        widget.expiredRenters[i],
                      );
                    },
                    child: Text(widget.expiredRenters[i]),
                  ),
                ),
              ),
            if ((widget.isOwner || widget.isCreativeOwner) &&
                widget.notExpiredRenters.isNotEmpty)
              SizedBox(
                width: max(480, MediaQuery.of(context).size.width * 0.8),
                child: const Text(
                  "Accounts with current rentals",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            if ((widget.isOwner || widget.isCreativeOwner) &&
                widget.notExpiredRenters.isNotEmpty)
              SizedBox(
                width: max(480, MediaQuery.of(context).size.width * 0.8),
                height: Theme.of(context).buttonTheme.height,
                child: ListView.builder(
                  itemCount: widget.notExpiredRenters.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) =>
                      SelectableText(widget.notExpiredRenters[i]),
                ),
              ),
            if (widget.isOwner)
              TokenSettingsFormField(
                inputLabel: "Transfer ownership license",
                save: (address) => setState(() {
                  _transferOwnershipLicenseTo = address ?? '';
                }),
                validate: widget.validateAddressField,
                successDescription:
                    "Ownership license transferred successfully.",
                updateToken: () async => await vm.transferOwnershipLicense(
                  widget.collectionAddress,
                  widget.tokenId,
                  _transferOwnershipLicenseTo,
                ),
              ),
            if (widget.isCreativeOwner)
              TokenSettingsFormField(
                inputLabel: "Set creative license price (ETH)",
                save: (number) => setState(() {
                  _creativeLicensePrice = double.tryParse(number ?? '') ?? 0;
                }),
                validate: widget.validateNumberField,
                successDescription:
                    "Creative license price updated successfully.",
                updateToken: () async => await vm.setCreativeLicensePrice(
                  widget.collectionAddress,
                  widget.tokenId,
                  _creativeLicensePrice,
                ),
              ),
            if (widget.isCreativeOwner &&
                widget.creativeLicenseRequests.isNotEmpty)
              SizedBox(
                width: max(480, MediaQuery.of(context).size.width * 0.8),
                height: Theme.of(context).buttonTheme.height,
                child: ListView.builder(
                  itemCount: widget.creativeLicenseRequests.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => OutlinedButton(
                    onPressed: () async {
                      await vm.approveCreative(
                        widget.collectionAddress,
                        widget.tokenId,
                        widget.creativeLicenseRequests[i],
                      );
                      await vm.removeCreativeLicenseTransferApproval(
                          widget.collectionAddress,
                          widget.tokenId,
                          widget.ownershipLicenseRequests[i]);
                    },
                    child: Text(widget.creativeLicenseRequests[i]),
                  ),
                ),
              ),
            if (widget.isCreativeOwner)
              TokenSettingsFormField(
                inputLabel: "Transfer creative license",
                save: (address) => setState(() {
                  _transferCreativeLicenseTo = address ?? '';
                }),
                validate: widget.validateAddressField,
                successDescription:
                    "Creative license transferred successfully.",
                updateToken: () async => await vm.transferCreativeLicense(
                  widget.collectionAddress,
                  widget.tokenId,
                  _transferCreativeLicenseTo,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
