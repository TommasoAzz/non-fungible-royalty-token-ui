import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/style_text/style_text.dart';
import '../../widgets/form_field/form_field.dart' as form;
import '../../widgets/text_box/text_box.dart';
import '../../constants/app_colors.dart';

class Token extends StatelessWidget {
  const Token({
    Key? key,
    this.isCreativeOwner = false,
    this.isOwnershipOwner = false,
    this.isCreator = false,
    required this.text,
  }) : super(key: key);
  final List<String> text;

  final bool isCreativeOwner;
  final bool isOwnershipOwner;
  final bool isCreator;

  @override
  Widget build(BuildContext context) {
    return Card(
        //color: secondaryColor,
        child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/ape.png'),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            height: 200,
            width: 400,
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.start,

              child: Container(
                child: Column(
                  children: [
                    StyleText(title: "Token Id: ${text[0]}"),
                    StyleText(title: "Owner: ${text[1]}"),
                    StyleText(title: "Creator: ${text[2]}"),
                    StyleText(title: "Rented by: ${text[3]}"),
                    StyleText(title: "Ownership license price: ${text[4]}"),
                    StyleText(title: "Creative license price: ${text[5]}"),
                    StyleText(title: "Rental price per second: ${text[6]}"),
                    if (isOwnershipOwner)
                      StyleText(title: "Ownership request from: ${text[7]}"),
                    if (isCreativeOwner)
                      StyleText(title: "Creative request from: ${text[8]}"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      if (isOwnershipOwner)
        const SizedBox(
            width: 500,
            child: form.FormField(inputLabel: "Set Ownership License price")),
      if (isOwnershipOwner)
        const SizedBox(
          width: 500,
          child: form.FormField(inputLabel: "Set Rental price per second"),
        ),
      if (isOwnershipOwner)
        const SizedBox(
          width: 500,
          child: form.FormField(inputLabel: "Transfer Ownership License to"),
        ),
      if (isCreativeOwner)
        const SizedBox(
            width: 500,
            child: form.FormField(inputLabel: "Set Creative License price")),
      if (isCreativeOwner)
        const SizedBox(
            width: 500,
            child: form.FormField(inputLabel: "Transfer Creative License to")),
    ]));
  }
}
