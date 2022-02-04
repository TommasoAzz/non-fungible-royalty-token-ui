import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'profile_content.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const ProfileContent(
        column: 1,
        padding: 10,
      ),
      tablet: const ProfileContent(column: 2, padding: 30),
      desktop: const ProfileContent(column: 3, padding: 30),
    );
  }
}
