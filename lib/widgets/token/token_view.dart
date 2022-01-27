import 'package:flutter/material.dart';
import '../../widgets/style_text/style_text.dart';
import '../../widgets/form_field/form_field.dart' as form;

class Token extends StatelessWidget {
  Token({
    Key? key,
    this.isCreativeOwner = false,
    this.isOwnershipOwner = false,
    this.isCreator = false,
    required this.text,
  }) : super(key: key);
  final List<String> text;

  final bool isCreativeOwner;
  final bool isOwnershipOwner;
  final bool isCreator;

  double _ownershipLicensePrice = 0;
  double _rentalPricePerSecond = 0;
  double _creativeLicensePrice = 0;
  String _transferOwnershipLicenseTo = '';
  String _transferCreativeLicenseTo = '';

  @override
  Widget build(BuildContext context) {
    return Card(
        //color: secondaryColor,
        child: Column(children: [
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
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.start,

              child: Column(
                children: [
                  StyleText(title: "Token Id: ${text[0]}"),
                  StyleText(title: "Owner: ${text[1]}"),
                  StyleText(title: "Creator: ${text[2]}"),
                  StyleText(title: "Rented by: ${text[3]}"),
                  StyleText(title: "Ownership license price: ${text[4]}"),
                  StyleText(title: "Creative license price: ${text[5]}"),
                  StyleText(title: "Rental price per second: ${text[6]}"),
                  StyleText(
                      title: "Royalty for ownership transfer: ${text[7]}"),
                  StyleText(title: "Royalty for rental: ${text[8]}"),
                  if (isOwnershipOwner)
                    StyleText(title: "Ownership request from: ${text[9]}"),
                  if (isCreativeOwner)
                    StyleText(title: "Creative request from: ${text[10]}"),
                ],
              ),
            ),
          ),
        ],
      ),
      if (isOwnershipOwner)
        SizedBox(
            width: 500,
            child: form.FormField(
              inputLabel: "Set Ownership License price",
              validationCallback: _validateNumberField,
              onSavedCallback: _saveOwnershipLicensePriceInputField,
            )),
      if (isOwnershipOwner)
        SizedBox(
          width: 500,
          child: form.FormField(
            inputLabel: "Set Rental price per second",
            validationCallback: _validateNumberField,
            onSavedCallback: _saveRentalPricePerSecondInputField,
          ),
        ),
      if (isOwnershipOwner)
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
    ]));
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
