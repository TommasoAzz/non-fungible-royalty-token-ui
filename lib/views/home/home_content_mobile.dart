import 'package:flutter/material.dart';
import '../../widgets/call_to_action/call_to_action_mobile.dart';
import '../../widgets/course_details/course_details.dart';

class HomeContentMobile extends StatelessWidget {
  const HomeContentMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CourseDetails(),
          SizedBox(
            height: 20,
          ),
          CallToActionMobile('Connect a wallet'),
        ],
      ),
    );
  }
}
