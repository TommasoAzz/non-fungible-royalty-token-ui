import 'package:flutter/material.dart';

class FormField extends StatelessWidget {
  /// Testo da visualizzare come descrizione del campo in cui inserire il testo.
  final String inputLabel;
  final String? Function(String?) validationCallback;
  final void Function(String?) onSavedCallback;

  const FormField({
    Key? key,
    required this.inputLabel,
    required this.validationCallback,
    required this.onSavedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Layout dell'input
      decoration: InputDecoration(
        labelText: inputLabel,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        errorStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).errorColor,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
      validator: validationCallback,
      onSaved: onSavedCallback,
    );
  }
}
