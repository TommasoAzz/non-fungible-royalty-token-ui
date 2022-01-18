import 'package:flutter/material.dart';
import '../../widgets/CallToAction/call_to_action.dart';
import '../../widgets/CourseDetails/course_details.dart';

class HomeContentMobile extends StatelessWidget {
  const HomeContentMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CourseDetails(),
        SizedBox(
          height: 100,
        ),
        CallToAction('Connect a wallet'),
      ],
    );
  }
}
