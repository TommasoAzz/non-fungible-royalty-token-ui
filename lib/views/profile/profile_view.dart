import 'package:flutter/material.dart';
import '../../widgets/profile_list/profile_list_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          Text(
            "MY PROFILE",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
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
