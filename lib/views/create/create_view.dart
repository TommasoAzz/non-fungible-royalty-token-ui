import 'package:flutter/material.dart';
import '../../business_logic/viewmodel/marketplace_vm.dart';
import '../../constants/app_colors.dart';
import '../../locator.dart';
import '../../widgets/dropzone/dropzone.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/number_slider_form_field/number_slider_form_field.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../widgets/form_field/form_field.dart' as form;

class CreateView extends StatefulWidget {
  const CreateView({Key? key}) : super(key: key);

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  final marketplaceVM = locator<MarketplaceVM>();

  @override
  void initState() {
    super.initState();
    marketplaceVM.addListener(update);
  }

  @override
  void dispose() {
    marketplaceVM.removeListener(update);
    super.dispose();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  bool collectionUploaded = false;

  bool uploadingCollection = false;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

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
                NumberSliderFormField(
                  title: "Set royalty (%) for ownership transfer",
                  saveValue: _saveOwnershipTransferInputField,
                ),
                NumberSliderFormField(
                  title: "Set royalty (%) for rental",
                  saveValue: _saveRentalInputField,
                ),
                const SizedBox(
                  height: 20,
                ),
                Dropzone(
                  saveUrl: _saveUrlFromDropzone,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (collectionUploaded)
                          const Text(
                            "Submitted",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        if (collectionUploaded) const Icon(Icons.check, size: 16),
                        if (!collectionUploaded)
                          const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        if (uploadingCollection) const SizedBox(width: 10),
                        if (uploadingCollection)
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
                    onPressed: _submitData,
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

    setState(() {
      uploadingCollection = true;
    });

    try {
      final collection = await marketplaceVM.deployNewCollection(
        _name,
        _symbol,
        _rentalRoyalty,
        _ownershipTransferRoyalty,
        _fileUrls,
      );

      setState(() {
        collectionUploaded = true;
        uploadingCollection = false;
        _form.currentState!.reset();
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const SelectableText('Successful deploy'),
          content: SelectableText(
            'Collection ${collection.name} (${collection.symbol}) was deployed successfully with ${collection.availableTokens} initial tokens.',
          ),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Okay'),
            )
          ],
        ),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (exc) {
      setState(() {
        collectionUploaded = false;
        uploadingCollection = false;
      });
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const SelectableText('Deploy not successful'),
          content: SelectableText(
            'The collection was not deployed. An error occurred: $exc',
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
