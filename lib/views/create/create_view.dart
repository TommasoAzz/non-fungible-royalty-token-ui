import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/slider/slider_number.dart';
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

  String _name = '';
  String _symbol = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 15),
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            const PageTitle(title: "create your collections"),
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
            const SliderNumber(
              title: "Set royalty for ownership transfer",
            ),
            const SliderNumber(
              title: "Set royalty for rental",
            ),
            Dropzone(),
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
  }

  String? _validateNameInputField(final String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validateSymbolInputField(final String? symbol) {
    if (symbol == null || symbol.isEmpty) {
      return 'Please enter a symbol';
    } else if (symbol.length != 6) {
      return 'Symbol must have six characters';
    }
    return null;
  }

  void _saveNameInputField(final String? name) => _name = name ?? '';

  void _saveSymbolInputField(final String? symbol) => _symbol = symbol ?? '';

  Future<void> _submitData() async {
    if (!_form.currentState!.validate()) return;

    _form.currentState!.save();

    //widget.loginFn(_name, _symbol);
  }
}
