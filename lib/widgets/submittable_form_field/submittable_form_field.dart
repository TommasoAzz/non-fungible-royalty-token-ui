import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/form_field/form_field.dart' as form;

class SubmittableFormField extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final void Function() submit;
  final String? Function(String?) validate;
  final void Function(String?) save;
  final String inputLabel;

  final bool dataUploaded;
  final bool uploadingData;

  const SubmittableFormField({
    Key? key,
    required this.formKey,
    required this.inputLabel,
    required this.validate,
    required this.save,
    required this.submit,
    required this.uploadingData,
    required this.dataUploaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: form.FormField(
              inputLabel: inputLabel,
              validationCallback: validate,
              onSavedCallback: save,
            ),
          ),
          ElevatedButton(
            child: Row(
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
            onPressed: submit,
          ),
        ],
      ),
    );
  }
}
