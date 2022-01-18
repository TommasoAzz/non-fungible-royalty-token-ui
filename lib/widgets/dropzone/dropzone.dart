import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../../../../constants/app_colors.dart';

class Dropzone extends StatefulWidget {
  @override
  _DropzoneState createState() => _DropzoneState();
}

class _DropzoneState extends State<Dropzone> {
  late DropzoneViewController controller;
  @override
  Widget build(BuildContext context) {
    const colorButton = primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
      //color: primaryColor,
      child: Stack(
        children: [
          DropzoneView(
              onCreated: (controller) => this.controller = controller,
              onDrop: acceptFile),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload, size: 80, color: Colors.grey),
                const Text(
                  "Drop file here",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    primary: colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: primaryColor)),
                  ),
                  icon: const Icon(Icons.search, size: 32),
                  label: const Text(
                    "Choose file",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () async {
                    final events = await controller.pickFiles();
                    if (events.isEmpty) return;

                    acceptFile(events.first);
                  },
                )
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Future acceptFile(dynamic event) async {
    final name = event.name;
    final mine = await controller.getFileMIME(event);
    final bytes = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    print('Name: $name');
    print('MINE: $mine');
    print('Bytes: $bytes');
    print('Url: $url');
  }
}
