import 'package:flutter/material.dart';
import '../submittable_form_field/submittable_form_field.dart';

class TokenSettingsFormField extends StatefulWidget {
  final String inputLabel;
  final String? Function(String?) validate;
  final void Function(String?) save;
  final String successDescription;
  final Future<void> Function() updateToken;

  const TokenSettingsFormField({
    Key? key,
    required this.inputLabel,
    required this.validate,
    required this.save,
    required this.successDescription,
    required this.updateToken,
  }) : super(key: key);

  @override
  _TokenSettingsFormFieldState createState() => _TokenSettingsFormFieldState();
}

class _TokenSettingsFormFieldState extends State<TokenSettingsFormField> {
  final _form = GlobalKey<FormState>();

  bool updated = false;
  bool updating = false;

  @override
  Widget build(BuildContext context) {
    return SubmittableFormField(
      formKey: _form,
      dataUploaded: updated,
      uploadingData: updating,
      inputLabel: widget.inputLabel,
      validate: widget.validate,
      save: widget.save,
      submit: _submit,
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;

    _form.currentState!.save();

    setState(() {
      updating = true;
    });

    try {
      await widget.updateToken();

      setState(() {
        updated = true;
        updating = false;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Operation successfull'),
          content: Text(widget.successDescription),
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
        updated = false;
        updating = false;
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
