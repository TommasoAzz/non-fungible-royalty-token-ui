import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../../../../constants/app_colors.dart';

class Dropzone extends StatefulWidget {
  final void Function(String) saveUrl;

  const Dropzone({
    required this.saveUrl,
  });

  @override
  _DropzoneState createState() => _DropzoneState();
}

class _DropzoneState extends State<Dropzone> {
  late DropzoneViewController controller;

  int numberFileUploaded = 0;

  @override
  Widget build(BuildContext context) {
    const colorButton = primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectableText(
          "Upload",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          height: 8,
        ),
        SelectableText(
          "Uploaded files: $numberFileUploaded",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
          height: 300,
          child: Stack(
            children: [
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.grab,
                onCreated: (controller) => this.controller = controller,
                onDrop: acceptFile,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload, size: 80, color: Colors.white),
                    const SelectableText(
                      "Drop file here",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.search, size: 25),
                      label: const Text(
                        "Choose file",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        primary: colorButton,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final events = await controller.pickFiles(multiple: true);
                        for (final event in events) {
                          await acceptFile(event);
                        }
                        setState(() {
                          numberFileUploaded += events.length;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Future<void> acceptFile(dynamic event) async {
    final name = event.name;
    final url = await controller.createFileUrl(event);
    print('Name: $name');
    print('Url: $url');
    widget.saveUrl(url);
  }
}
