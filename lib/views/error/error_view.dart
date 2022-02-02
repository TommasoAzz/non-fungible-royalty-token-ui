import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key, n}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          SelectableText("404",
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w200,
                color: primaryColor,
              ),
              textAlign: TextAlign.center),
          SelectableText(
            "Page not found",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
