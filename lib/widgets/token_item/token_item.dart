import 'dart:async';

import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/constants/app_colors.dart';
import 'token_info.dart';
import '../../business_logic/models/collection.dart';
import '../../business_logic/models/token.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../submittable_form_field/submittable_form_field.dart';
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

  final setOwnershipLicensePriceKey = GlobalKey<FormState>();
  bool ownershipPriceUploaded = false;
  bool uploadingOwnershipPrice = false;
  double _ownershipLicensePrice = 0;

  final setRentalPriceKey = GlobalKey<FormState>();
  bool rentalPriceUploaded = false;
  bool uploadingRentalPrice = false;
  double _rentalPricePerSecond = 0;

  final setCreativeLicensePriceKey = GlobalKey<FormState>();
  bool creativePriceUploaded = false;
  bool uploadingCreativePrice = false;
  double _creativeLicensePrice = 0;

  final transferOwnershipLicenseKey = GlobalKey<FormState>();
  bool transferOwnershipUploaded = false;
  bool uploadingTransferOwnership = false;
  String _transferOwnershipLicenseTo = '';

  final transferCreativeLicenseKey = GlobalKey<FormState>();
  bool transferCreativeUploaded = false;
  bool uploadingTransferCreative = false;
  String _transferCreativeLicenseTo = '';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        openRent();
                      },
                      child: const Text("Rent")),
                  if (widget.isOwner || widget.isCreativeOwner)
                    ElevatedButton(
                      onPressed: () {
                        openDialogSettings();
                      },
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

  Future openRent() => showDialog(
        context: context,
        builder: (contex) => AlertDialog(
          title: Text("Rent this token"),
          content: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => pickDate(context),
                child: expirationDate == null
                    ? Text('Select date')
                    : Text(
                        'Selected date: ${expirationDate!.day}/${expirationDate!.month}/${expirationDate!.year}'),
              ),
              rentExpirationDateInMillis == 0
                  ? Text("")
                  : Text(
                      "The cost for this rent is: ${rentExpirationDateInMillis * 1000 * _rentalPricePerSecond} "),
              ElevatedButton(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (rented)
                      const Text(
                        "Submitted",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    if (rented) const Icon(Icons.check_box, size: 16),
                    if (!rented)
                      const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    if (renting) const SizedBox(width: 10),
                    if (renting)
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _submitRent,
              ),
            ],
          ),
        ),
      );

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;
    setState(() {
      expirationDate = newDate;
      rentExpirationDateInMillis =
          (expirationDate!.difference(DateTime.now()).inMilliseconds);
    });
  }

  Future openDialogSettings() => showDialog(
        context: context,
        builder: (contex) => AlertDialog(
          content: Column(
            children: [
              if (widget.isOwner)
                SizedBox(
                  width: 500,
                  child: SubmittableFormField(
                    formKey: setOwnershipLicensePriceKey,
                    inputLabel: "Set Ownership License price",
                    validate: _validateNumberField,
                    save: _saveOwnershipLicensePriceInputField,
                    submit: _submitOwnershipLicensePrice,
                    uploadingData: uploadingOwnershipPrice,
                    dataUploaded: ownershipPriceUploaded,
                  ),
                ),
              if (widget.isOwner)
                SizedBox(
                  width: 500,
                  child: SubmittableFormField(
                    formKey: setRentalPriceKey,
                    inputLabel: "Set Rental price per second",
                    validate: _validateNumberField,
                    save: _saveRentalPricePerSecondInputField,
                    submit: _submitRentalPrice,
                    uploadingData: uploadingRentalPrice,
                    dataUploaded: rentalPriceUploaded,
                  ),
                ),
              if (widget.isOwner)
                SizedBox(
                  width: 500,
                  child: SubmittableFormField(
                    formKey: transferOwnershipLicenseKey,
                    inputLabel: "Transfer Ownership License to",
                    validate: _validateAddressField,
                    save: _saveTransferOwnershipLicenseInputField,
                    submit: _submitTransferOwnershipLicense,
                    uploadingData: uploadingTransferOwnership,
                    dataUploaded: transferOwnershipUploaded,
                  ),
                ),
              if (widget.isCreativeOwner)
                SizedBox(
                    width: 500,
                    child: SubmittableFormField(
                      formKey: setCreativeLicensePriceKey,
                      inputLabel: "Set Creative License price",
                      validate: _validateNumberField,
                      save: _saveCreativeLicensePriceInputField,
                      submit: _submitCreativeLicensePrice,
                      dataUploaded: creativePriceUploaded,
                      uploadingData: uploadingCreativePrice,
                    )),
              if (widget.isCreativeOwner)
                SizedBox(
                  width: 500,
                  child: SubmittableFormField(
                    formKey: transferCreativeLicenseKey,
                    inputLabel: "Transfer Creative License to",
                    validate: _validateAddressField,
                    save: _saveTransferCreativeLicenseInputField,
                    submit: _submitTransferCreativeLicense,
                    dataUploaded: transferCreativeUploaded,
                    uploadingData: uploadingTransferCreative,
                  ),
                ),
            ],
          ),
        ),
      );

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

  Future<void> _submitOwnershipLicensePrice() async {
    if (!setOwnershipLicensePriceKey.currentState!.validate()) return;
    setOwnershipLicensePriceKey.currentState!.save();

    setState(() {
      uploadingOwnershipPrice = true;
    });

    try {
      await marketplaceVM.setOwnershipLicensePrice(
        widget.collection.address,
        widget.token.id,
        _ownershipLicensePrice,
      );

      setState(() {
        ownershipPriceUploaded = true;
        uploadingOwnershipPrice = false;
        setOwnershipLicensePriceKey.currentState!.reset();
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ownership license price changed successfully'),
          content: Text(
            'Ownership license price of token ${widget.token.id} is now set to $_ownershipLicensePrice ETH',
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
        ownershipPriceUploaded = false;
        uploadingOwnershipPrice = false;
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

  Future<void> _submitRentalPrice() async {
    if (!setRentalPriceKey.currentState!.validate()) return;
    setRentalPriceKey.currentState!.save();

    setState(() {
      uploadingRentalPrice = true;
    });

    try {
      await marketplaceVM.setRentalPrice(
        widget.collection.address,
        widget.token.id,
        _rentalPricePerSecond,
      );

      setState(() {
        rentalPriceUploaded = true;
        uploadingRentalPrice = false;
        setRentalPriceKey.currentState!.reset();
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Rental price changed successfully'),
          content: Text(
            'Rental price per second of token ${widget.token.id} is now set to $_rentalPricePerSecond ETH/sec',
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
        rentalPriceUploaded = false;
        uploadingRentalPrice = false;
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

  Future<void> _submitCreativeLicensePrice() async {
    if (!setCreativeLicensePriceKey.currentState!.validate()) return;
    setCreativeLicensePriceKey.currentState!.save();

    setState(() {
      uploadingCreativePrice = true;
    });

    try {
      await marketplaceVM.setCreativeLicensePrice(
        widget.collection.address,
        widget.token.id,
        _creativeLicensePrice,
      );

      setState(() {
        creativePriceUploaded = true;
        uploadingCreativePrice = false;
        setCreativeLicensePriceKey.currentState!.reset();
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Creative license price changed successfully'),
          content: Text(
            'Creative license price of token ${widget.token.id} is now set to $_creativeLicensePrice ETH ',
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
        creativePriceUploaded = false;
        uploadingCreativePrice = false;
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

  Future<void> _submitTransferCreativeLicense() async {
    if (!transferCreativeLicenseKey.currentState!.validate()) return;
    transferCreativeLicenseKey.currentState!.save();

    setState(() {
      uploadingTransferCreative = true;
    });

    try {
      await marketplaceVM.transferCreativeLicense(
        widget.collection.address,
        widget.token.id,
        _transferCreativeLicenseTo,
      );

      setState(() {
        transferCreativeUploaded = true;
        uploadingTransferCreative = false;
        transferCreativeLicenseKey.currentState!.reset();
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Creative license transferred successfully'),
          content: Text(
            'Creative license of token ${widget.token.id} was transferred to $_transferCreativeLicenseTo ',
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
        transferCreativeUploaded = false;
        uploadingTransferCreative = false;
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

  Future<void> _submitTransferOwnershipLicense() async {
    if (!transferOwnershipLicenseKey.currentState!.validate()) return;
    transferOwnershipLicenseKey.currentState!.save();

    setState(() {
      uploadingTransferOwnership = true;
    });

    try {
      await marketplaceVM.transferOwnershipLicense(
        widget.collection.address,
        widget.token.id,
        _transferOwnershipLicenseTo,
      );

      setState(() {
        transferOwnershipUploaded = true;
        uploadingTransferOwnership = false;
        transferOwnershipLicenseKey.currentState!.reset();
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ownership license transferred successfully'),
          content: Text(
            'Ownership license of token ${widget.token.id} was transfered to $_transferOwnershipLicenseTo ',
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
        transferOwnershipUploaded = false;
        uploadingTransferOwnership = false;
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
    // if (!rentKey.currentState!.validate()) return;
    // rentKey.currentState!.save();

    setState(() {
      renting = true;
    });

    try {
      await marketplaceVM.rentAsset(widget.collection.address, widget.token.id,
          rentExpirationDateInMillis);

      setState(() {
        rented = true;
        renting = false;
        //transferOwnershipLicenseKey.currentState!.reset();
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Token rented successfully'),
          content: Text(
            'Token ${widget.token.id} is rented until $expirationDate ',
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
