import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/locator.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/services/navigation_service.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/hover/on_hover_button.dart';
import '../../../../constants/app_colors.dart';

class CallToActionMobile extends StatelessWidget {
  final String title;
  // ignore: use_key_in_widget_constructors
  const CallToActionMobile(this.title);

  @override
  Widget build(BuildContext context) {
    return OnHoverButton(
      child: ElevatedButton(
        onPressed: () => {
          locator<NavigationService>().navigateTo("wallet"),
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
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
      ),
    );
  }
}
