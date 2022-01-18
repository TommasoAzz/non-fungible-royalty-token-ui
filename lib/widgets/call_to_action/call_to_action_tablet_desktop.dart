import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class CallToActionTabletDesktop extends StatelessWidget {
  final String title;
  // ignore: use_key_in_widget_constructors
  const CallToActionTabletDesktop(this.title);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        // TODO(dominego): Connect to wallet.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
