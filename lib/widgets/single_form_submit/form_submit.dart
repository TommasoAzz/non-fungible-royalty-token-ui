import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/collection.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/models/token.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/business_logic/viewmodel/marketplace_vm.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/constants/app_colors.dart';
import '../../locator.dart';
import '../../widgets/style_text/style_text.dart';
import '../../widgets/form_field/form_field.dart' as form;

class SubmitForm extends StatefulWidget {
  SubmitForm(
      {Key? key,
      required this.inputLabel,
      required this.validationData,
      required this.saveData,
      required this.submitData})
      : super(key: key);

  @override
  State<SubmitForm> createState() => _SubmitFormState();

  final void Function()? submitData;
  final String? Function(String?) validationData;
  final void Function(String?) saveData;
  final String inputLabel;
}

class _SubmitFormState extends State<SubmitForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool dataUploaded = false;
  bool uploadingData = false;
  double _ownershipLicensePrice = 0;
  double _rentalPricePerSecond = 0;
  double _creativeLicensePrice = 0;
  String _transferOwnershipLicenseTo = '';
  String _transferCreativeLicenseTo = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: 500,
              child: form.FormField(
                inputLabel: widget.inputLabel,
                validationCallback: widget.validationData,
                onSavedCallback: widget.saveData,
              )),
          ElevatedButton(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (dataUploaded)
                  const Text(
                    "Submitted",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                if (dataUploaded) const Icon(Icons.check_box, size: 16),
                if (!dataUploaded)
                  const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                if (uploadingData) const SizedBox(width: 10),
                if (uploadingData)
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
            onPressed: widget.submitData,
          ),
        ],
      ),
    );
  }
}
