import 'package:flutter/material.dart';
import '../../widgets/call_to_action/call_to_action_tablet_desktop.dart';
import '../../widgets/course_details/course_details.dart';

class HomeContentDesktop extends StatelessWidget {
  const HomeContentDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        CourseDetails(),
        Expanded(
          child: Center(
            child: CallToActionTabletDesktop('Connect a wallet'),
          ),
        )
      ],
    );
  }
}
