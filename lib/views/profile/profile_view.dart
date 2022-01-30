import 'package:flutter/material.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/profile_collection_list/profile_collection_list.dart';

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
          ProfileCollectionList(title: "Created"),
          SizedBox(
            height: 20,
          ),
          ProfileCollectionList(title: "Ownership license"),
          SizedBox(
            height: 20,
          ),
          ProfileCollectionList(title: "Creative license"),
          SizedBox(
            height: 20,
          ),
          ProfileCollectionList(title: "Rented")
        ],
      ),
    );
  }
}
