import 'package:flutter/material.dart';
import '../../widgets/CallToAction/call_to_action.dart';
import '../../widgets/CourseDetails/course_details.dart';

class HomeContentDesktop extends StatelessWidget {
  const HomeContentDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CourseDetails(),
        Expanded(
          child: Center(
            child: CallToAction('Connect a wallet'),
          ),
        )
      ],
    );
  }
}
