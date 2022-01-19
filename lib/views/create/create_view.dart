import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dropzone/dropzone.dart';
import '../../widgets/text_box/text_box.dart';

class CreateView extends StatelessWidget {
  const CreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: Column(
        children: <Widget>[
          const Text(
            "CREATE YOUR COLLECTION",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const TextBox(title: "Collection name"),
          const TextBox(title: "Symbol"),
          const TextBox(title: "Base URI"),
          Dropzone(),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
