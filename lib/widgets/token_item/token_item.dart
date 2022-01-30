import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/collection.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/token.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/viewmodel/marketplace_vm.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/constants/app_colors.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/single_form_submit/form_submit.dart';
import '../../locator.dart';
import '../../widgets/style_text/style_text.dart';
import '../../widgets/form_field/form_field.dart' as form;

class TokenItem extends StatefulWidget {
  TokenItem({
    Key? key,
    required this.isCreativeOwner,
    required this.isOwner,
    required this.token,
    required this.collection,
  }) : super(key: key);

  @override
  State<TokenItem> createState() => _TokenItemState();

  final Collection collection;
  final Token token;
  final bool isCreativeOwner;
  final bool isOwner;
}

class _TokenItemState extends State<TokenItem> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final marketplaceVM = locator<MarketplaceVM>();

  bool ownershipPriceUploaded = false;
  bool uploadingOwnershipPrice = false;

  bool rentalPriceUploaded = false;
  bool uploadingRentalPrice = false;

  bool creativePriceUploaded = false;
  bool uploadingCreativePrice = false;

  bool transferOwnershipUploaded = false;
  bool uploadingTransferOwnership = false;

  bool transferCreativeUploaded = false;
  bool uploadingTransferCreative = false;

  double _ownershipLicensePrice = 0;
  double _rentalPricePerSecond = 0;
  double _creativeLicensePrice = 0;
  String _transferOwnershipLicenseTo = '';
  String _transferCreativeLicenseTo = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
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
                height: 210,
                width: 400,
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  //mainAxisSize: MainAxisSize.max,
                  //crossAxisAlignment: CrossAxisAlignment.start,

                  child: Column(
                    children: [
                      StyleText(
                        title: "ID: ${widget.token.id}",
                      ),
                      StyleText(
                        title: "Owner: ${widget.token.owner}",
                      ),
                      StyleText(
                        title:
                            "Rented by: ${widget.token.rentedBy.length} people",
                      ),
                      StyleText(
                        title:
                            "Ownership license price: ${widget.token.ownershipLicensePrice} ETH",
                      ),
                      StyleText(
                        title:
                            "Creative license price: ${widget.token.creativeLicensePrice} ETH",
                      ),
                      StyleText(
                        title:
                            "Rental price per second: ${widget.token.rentalPricePerSecond} ETH/sec",
                      ),
                      StyleText(
                        title:
                            "Royalty for ownership transfer: ${widget.token.royaltyOwnershipTransfer}",
                      ),
                      StyleText(
                        title:
                            "Royalty for rental: ${widget.token.royaltyRental}",
                      ),
                      if (widget.isOwner)
                        StyleText(
                          title:
                              "Ownership requests from: ${widget.token.ownershipLicenseRequests}",
                        ),
                      if (widget.isCreativeOwner)
                        StyleText(
                          title:
                              "Creative requests from: ${widget.token.creativeLicenseRequests}",
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Form(
            key: _form,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.isOwner)
                  SizedBox(
                      width: 500,
                      child: SubmitForm(
                        inputLabel: "Set Ownership License price",
                        validationData: _validateNumberField,
                        saveData: _saveOwnershipLicensePriceInputField,
                        submitData: _submitOwnershipLicensePrice,
                      )),
                if (widget.isOwner)
                  SizedBox(
                    width: 500,
                    child: SubmitForm(
                      inputLabel: "Set Rental price per second",
                      validationData: _validateNumberField,
                      saveData: _saveRentalPricePerSecondInputField,
                      submitData: _submitRentalPrice,
                    ),
                  ),
                if (widget.isOwner)
                  SizedBox(
                    width: 500,
                    child: SubmitForm(
                      inputLabel: "Transfer Ownership License to",
                      validationData: _validateAddressField,
                      saveData: _saveTransferOwnershipLicenseInputField,
                      submitData: _submitTransferOwnershipLicense,
                    ),
                  ),
                if (widget.isCreativeOwner)
                  SizedBox(
                      width: 500,
                      child: SubmitForm(
                        inputLabel: "Set Creative License price",
                        validationData: _validateNumberField,
                        saveData: _saveCreativeLicensePriceInputField,
                        submitData: _submitCreativeLicensePrice,
                      )),
                if (widget.isCreativeOwner)
                  SizedBox(
                    width: 500,
                    child: SubmitForm(
                      inputLabel: "Transfer Creative License to",
                      validationData: _validateAddressField,
                      saveData: _saveTransferCreativeLicenseInputField,
                      submitData: _submitTransferCreativeLicense,
                    ),
                  ),
              ],
            ),
          ),
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

  Future<void> _submitOwnershipLicensePrice() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

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
        _form.currentState!.reset();
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
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

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
        _form.currentState!.reset();
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
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

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
        _form.currentState!.reset();
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
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

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
        _form.currentState!.reset();
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
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

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
        _form.currentState!.reset();
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
}
