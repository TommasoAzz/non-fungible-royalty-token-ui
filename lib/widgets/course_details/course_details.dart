import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      var textAlignment =
          // ignore: deprecated_member_use
          sizingInformation.deviceScreenType == DeviceScreenType.Desktop
              ? TextAlign.left
              : TextAlign.center;

      double titleSize =
          // ignore: deprecated_member_use
          sizingInformation.deviceScreenType == DeviceScreenType.Mobile ? 50 : 80;
      double descriptionSize =
          // ignore: deprecated_member_use
          sizingInformation.deviceScreenType == DeviceScreenType.Mobile ? 16 : 21;
      return SizedBox(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'WELCOME TO ERC1190. MARKETPLACE',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                height: 0.9,
                fontSize: titleSize,
              ),
              textAlign: textAlignment,
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 30,
            ),
            Text(
              'Project on the ERC-1190 proposal "Non-Fungible Royalty Token". Made for the course "Blockchain and Cryptocurrencies", University of Bologna, A.Y. 2021/2022.',
              style: TextStyle(
                fontSize: descriptionSize,
                height: 1.7,
              ),
              textAlign: textAlignment,
            )
          ],
        ),
      );
    });
  }
}
