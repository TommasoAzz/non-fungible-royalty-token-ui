import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/page_title/page_title.dart';
import '../../widgets/profile_list/profile_list_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          PageTitle(title: "My Profile"),
          SizedBox(
            height: 20,
          ),
          ProfileListView(title: "Created"),
          SizedBox(
            height: 20,
          ),
          ProfileListView(title: "Ownership license"),
          SizedBox(
            height: 20,
          ),
          ProfileListView(title: "Creative license"),
          SizedBox(
            height: 20,
          ),
          ProfileListView(title: "Rented")
        ],
      ),
    );
  }
}
