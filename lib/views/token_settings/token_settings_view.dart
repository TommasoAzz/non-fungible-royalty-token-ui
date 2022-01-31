import 'dart:math';

import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/submittable_form_field/submittable_form_field.dart';

class TokenSettingsView extends StatelessWidget {
  final String? Function(String?) validateNumberField;
  final String? Function(String?) validateAddressField;

  final bool isOwner;
  final bool isCreativeOwner;

  final GlobalKey<FormState> setOwnershipLicensePriceKey;
  final GlobalKey<FormState> setRentalPriceKey;
  final GlobalKey<FormState> setCreativeLicensePriceKey;
  final GlobalKey<FormState> transferOwnershipLicenseKey;
  final GlobalKey<FormState> transferCreativeLicenseKey;

  final void Function(String?) saveOwnershipLicensePriceInputField;
  final void Function(String?) saveCreativeLicensePriceInputField;
  final void Function(String?) saveRentalPricePerSecondInputField;
  final void Function(String?) saveTransferOwnershipLicenseInputField;
  final void Function(String?) saveTransferCreativeLicenseInputField;

  final void Function() submitOwnershipLicensePrice;
  final void Function() submitRentalPrice;
  final void Function() submitTransferOwnershipLicense;
  final void Function() submitCreativeLicensePrice;
  final void Function() submitTransferCreativeLicense;

  final bool ownershipPriceUploaded;
  final bool uploadingOwnershipPrice;

  final bool rentalPriceUploaded;
  final bool uploadingRentalPrice;

  final bool creativePriceUploaded;
  final bool uploadingCreativePrice;

  final bool transferOwnershipUploaded;
  final bool uploadingTransferOwnership;

  final bool transferCreativeUploaded;
  final bool uploadingTransferCreative;

  const TokenSettingsView({
    Key? key,
    required this.validateNumberField,
    required this.validateAddressField,
    required this.isCreativeOwner,
    required this.isOwner,
    required this.setOwnershipLicensePriceKey,
    required this.setCreativeLicensePriceKey,
    required this.setRentalPriceKey,
    required this.transferCreativeLicenseKey,
    required this.transferOwnershipLicenseKey,
    required this.saveOwnershipLicensePriceInputField,
    required this.saveCreativeLicensePriceInputField,
    required this.saveRentalPricePerSecondInputField,
    required this.saveTransferOwnershipLicenseInputField,
    required this.saveTransferCreativeLicenseInputField,
    required this.submitCreativeLicensePrice,
    required this.submitOwnershipLicensePrice,
    required this.submitRentalPrice,
    required this.submitTransferCreativeLicense,
    required this.submitTransferOwnershipLicense,
    required this.creativePriceUploaded,
    required this.ownershipPriceUploaded,
    required this.rentalPriceUploaded,
    required this.transferCreativeUploaded,
    required this.transferOwnershipUploaded,
    required this.uploadingCreativePrice,
    required this.uploadingOwnershipPrice,
    required this.uploadingRentalPrice,
    required this.uploadingTransferCreative,
    required this.uploadingTransferOwnership,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: SubmittableFormField(
              formKey: setOwnershipLicensePriceKey,
              inputLabel: "Set Ownership License price",
              validate: validateNumberField,
              save: saveOwnershipLicensePriceInputField,
              submit: submitOwnershipLicensePrice,
              uploadingData: uploadingOwnershipPrice,
              dataUploaded: ownershipPriceUploaded,
            ),
          ),
        if (isOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: SubmittableFormField(
              formKey: setRentalPriceKey,
              inputLabel: "Set Rental price per second",
              validate: validateNumberField,
              save: saveRentalPricePerSecondInputField,
              submit: submitRentalPrice,
              uploadingData: uploadingRentalPrice,
              dataUploaded: rentalPriceUploaded,
            ),
          ),
        if (isOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: SubmittableFormField(
              formKey: transferOwnershipLicenseKey,
              inputLabel: "Transfer Ownership License to",
              validate: validateAddressField,
              save: saveTransferOwnershipLicenseInputField,
              submit: submitTransferOwnershipLicense,
              uploadingData: uploadingTransferOwnership,
              dataUploaded: transferOwnershipUploaded,
            ),
          ),
        if (isCreativeOwner)
          Container(
              constraints: BoxConstraints(
                maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
              ),
              child: SubmittableFormField(
                formKey: setCreativeLicensePriceKey,
                inputLabel: "Set Creative License price",
                validate: validateNumberField,
                save: saveCreativeLicensePriceInputField,
                submit: submitCreativeLicensePrice,
                dataUploaded: creativePriceUploaded,
                uploadingData: uploadingCreativePrice,
              )),
        if (isCreativeOwner)
          Container(
            constraints: BoxConstraints(
              maxWidth: max(480, MediaQuery.of(context).size.width * 0.8),
            ),
            child: SubmittableFormField(
              formKey: transferCreativeLicenseKey,
              inputLabel: "Transfer Creative License to",
              validate: validateAddressField,
              save: saveTransferCreativeLicenseInputField,
              submit: submitTransferCreativeLicense,
              dataUploaded: transferCreativeUploaded,
              uploadingData: uploadingTransferCreative,
            ),
          ),
      ],
    );
  }
}
