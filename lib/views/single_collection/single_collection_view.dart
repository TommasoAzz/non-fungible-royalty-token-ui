import 'package:flutter/material.dart';
import 'package:non_fungible_royalty_token_marketplace_ui/widgets/page_title/page_title.dart';
import '../../widgets/profile_list/profile_list_view.dart';

class SingleCollectionView extends StatelessWidget {
  const SingleCollectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          const PageTitle(title: "my profile"),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
