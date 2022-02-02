import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:intl/intl.dart';
import '../../views/token_settings/token_settings_view.dart';
import '../../views/rent_token/rent_token_view.dart';
import 'token_info.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/models/token.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../locator.dart';

class TokenItem extends StatefulWidget {
  final Collection collection;
  final Token token;
  final bool isCreativeOwner;
  final bool isOwner;

  const TokenItem({
    Key? key,
    required this.isCreativeOwner,
    required this.isOwner,
    required this.token,
    required this.collection,
  }) : super(key: key);

  @override
  State<TokenItem> createState() => _TokenItemState();
}

class _TokenItemState extends State<TokenItem> {
  final marketplaceVM = locator<MarketplaceVM>();

  DateTime? expirationDate;
  int rentExpirationDateInMillis = 0;
  bool rented = false;
  bool renting = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 180,
                ),
                child: Center(child: Image.network(widget.token.uri)),
              ),
              TokenInfo(
                token: widget.token,
                showCreativeOwnershipRequests: widget.isCreativeOwner,
                showOwnershipRequests: widget.isOwner,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (widget.token.rentalPricePerSecond > 0)
                    ElevatedButton(
                        onPressed: openRent, child: const Text("Rent")),
                  if (!widget.isOwner &&
                      widget.token.ownershipLicensePrice != 0)
                    ElevatedButton(
                      onPressed: obtainOwnershipLicense,
                      child: const Text("Obtain ownership license"),
                    ),
                  if (!widget.isCreativeOwner &&
                      widget.token.creativeLicensePrice != 0)
                    ElevatedButton(
                      onPressed: obtainCreativeLicense,
                      child: const Text("Obtain creative license"),
                    ),
                  if (widget.isOwner || widget.isCreativeOwner)
                    ElevatedButton(
                      onPressed: openDialogSettings,
                      child: const Text("Settings"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openRent() async {
    await showDialog(
      context: context,
      builder: (context) => RentTokenView(
        title: 'Rent this token',
        rented: rented,
        renting: renting,
        submitRent: _submitRent,
        updateRentalData: _updateRentalData,
        rentalPricePerSecond: widget.token.rentalPricePerSecond,
        expirationDate: expirationDate,
        rentExpirationDateInMillis: rentExpirationDateInMillis,
      ),
    );
  }

  Future<void> openDialogSettings() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TokenSettingsView(
          validateAddressField: _validateAddressField,
          validateNumberField: _validateNumberField,
          isCreativeOwner: widget.isCreativeOwner,
          isOwner: widget.isOwner,
          collectionAddress: widget.collection.address,
          tokenId: widget.token.id,
        ),
      ),
    );
  }

  String? _validateAddressField(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value.';
    } else if (EthUtils.isAddress(value)) {
      return 'Please enter a valid address.';
    }
    return null;
  }

  String? _validateNumberField(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value.';
    } else {
      final parsed = double.tryParse(value);
      if (parsed != null && parsed < 0) {
        return 'Please enter a positive value.';
      }
    }
    return null;
  }

  void _updateRentalData(
      final DateTime expirationDate, final int rentExpirationDateInMillis) {
    setState(() {
      this.expirationDate = expirationDate;
      this.rentExpirationDateInMillis = rentExpirationDateInMillis;
    });
  }

  Future<void> obtainOwnershipLicense() async {
    try {
      await marketplaceVM.obtainOwnershipLicense(
        widget.collection.address,
        widget.token.id,
      );
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ownership license obtained successfully'),
          content: Text(
            "Ownership license of token ${widget.token.id} was obtained.",
          ),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
      //ignore: avoid_catches_without_on_clauses
    } catch (exc) {
      setState(() {
        rented = false;
        renting = false;
      });
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Operation not successful'),
          content: Text(
            'The operation was not completed. An error occurred: $exc',
          ),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  Future<void> obtainCreativeLicense() async {
    try {
      await marketplaceVM.obtainCreativeLicense(
        widget.collection.address,
        widget.token.id,
      );
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Creative license obtained successfully'),
          content: Text(
            "Creative license of token ${widget.token.id} was obtained.",
          ),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
      //ignore: avoid_catches_without_on_clauses
    } catch (exc) {
      setState(() {
        rented = false;
        renting = false;
      });
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Operation not successful'),
          content: Text(
            'The operation was not completed. An error occurred: $exc',
          ),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  Future<void> _submitRent() async {
    setState(() {
      renting = true;
    });

    try {
      await marketplaceVM.rentAsset(
        widget.collection.address,
        widget.token.id,
        rentExpirationDateInMillis,
      );

      setState(() {
        rented = true;
        renting = false;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Token rented successfully'),
          content: Text(
            "Token ${widget.token.id} is rented until ${DateFormat('gg/MM/yy').format(expirationDate!)}.",
          ),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
      //ignore: avoid_catches_without_on_clauses
    } catch (exc) {
      setState(() {
        rented = false;
        renting = false;
      });
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Operation not successful'),
          content: Text(
            'The operation was not completed. An error occurred: $exc',
          ),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }
}
