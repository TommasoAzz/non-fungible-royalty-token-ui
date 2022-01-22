import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            const PageTitle(title: "create your collections"),
            const form.FormField(
              inputLabel: "Collection name",
            ),
            const SizedBox(
              height: 40,
            ),
            const form.FormField(
              inputLabel: "Symbol",
            ),
            const SizedBox(
              height: 40,
            ),
            const form.FormField(
              inputLabel: "Base URI",
            ),
            const SizedBox(
              height: 40,
            ),
            Dropzone(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _checkData,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkData() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.validate();
  }
}
