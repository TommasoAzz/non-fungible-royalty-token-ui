import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key, n}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TokenItem(text: [
        //   "A",
        //   "A",
        //   "A",
        //   "A",
        //   "A",
        //   "A",
        //   "A",
        //   "A",
        //   "A",
        //   "A",
        //   "A",
        // ])
        SizedBox(height: 230),
        Text("404",
            style: TextStyle(
              fontSize: 90,
              fontWeight: FontWeight.w200,
              color: primaryColor,
            ),
            textAlign: TextAlign.center),
        Text("Page not found",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
            textAlign: TextAlign.center)
      ],
    );
  }
}
