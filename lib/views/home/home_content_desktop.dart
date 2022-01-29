import 'package:flutter/material.dart';
import '../../widgets/call_to_action/call_to_action.dart';
import '../../widgets/course_details/course_details.dart';

class HomeContentDesktop extends StatelessWidget {
  const HomeContentDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        MarketplaceBanner(),
        Expanded(
          child: Center(
            child: CallToAction('Connect a wallet'),
          ),
        )
      ],
    );
  }
}
