import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/Dropzone/dropzone.dart';
import '../../widgets/TextBox/text_box.dart';

class CreateView extends StatelessWidget {
  const CreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: Column(
        children: [
          TextBox(
            title: "Collection name",
          ),
          TextBox(title: "Symbol"),
          TextBox(title: "Base URI"),
          Text(
            "Upload ",
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Dropzone(),
        ],
      ),
      decoration: BoxDecoration(
        color: secondaryyColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
