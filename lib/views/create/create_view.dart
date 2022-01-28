import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../widgets/slider/slider_number.dart';
import '../../locator.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/form_field/form_field.dart' as form;
import '../../widgets/dropzone/dropzone.dart';

class CreateView extends StatefulWidget {
  const CreateView({Key? key}) : super(key: key);

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final marketplaceVM = locator<MarketplaceVM>();

  String _name = '';

  String _symbol = '';

  int _ownershipTransferRoyalty = 0;

  int _rentalRoyalty = 0;

  final _fileUrls = <String>[];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: sizingInformation.isMobile ? 20 : 200,
          ),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                const PageTitle(title: "create your collection"),
                form.FormField(
                  inputLabel: "Collection name",
                  validationCallback: _validateNameInputField,
                  onSavedCallback: _saveNameInputField,
                ),
                const SizedBox(
                  height: 40,
                ),
                form.FormField(
                  inputLabel: "Symbol",
                  validationCallback: _validateSymbolInputField,
                  onSavedCallback: _saveSymbolInputField,
                ),
                const SizedBox(
                  height: 40,
                ),
                SliderNumber(
                  title: "Set royalty for ownership transfer",
                  saveValue: _saveOwnershipTransferInputField,
                ),
                SliderNumber(
                  title: "Set royalty for rental",
                  saveValue: _saveRentalInputField,
                ),
                Dropzone(
                  saveUrl: _saveUrlFromDropzone,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _submitData,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _validateNameInputField(final String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter a valid name (non empty).';
    }
    return null;
  }

  String? _validateSymbolInputField(final String? symbol) {
    if (symbol == null || symbol.isEmpty) {
      return 'Please enter a valid symbol for this collection (six characters).';
    } else if (symbol.length != 6) {
      return 'Symbols must be six characters long.';
    }
    return null;
  }

  void _saveNameInputField(final String? name) => _name = name ?? '';

  void _saveSymbolInputField(final String? symbol) => _symbol = symbol ?? '';

  void _saveOwnershipTransferInputField(final double value) =>
      _ownershipTransferRoyalty = value.toInt();

  void _saveRentalInputField(final double value) => _rentalRoyalty = value.toInt();

  void _saveUrlFromDropzone(final String value) => _fileUrls.add(value);

  Future<void> _submitData() async {
    if (!_form.currentState!.validate()) return;

    _form.currentState!.save();

    await marketplaceVM.deployNewCollection(
      _name,
      _symbol,
      _rentalRoyalty,
      _ownershipTransferRoyalty,
      _fileUrls,
    );
  }
}
