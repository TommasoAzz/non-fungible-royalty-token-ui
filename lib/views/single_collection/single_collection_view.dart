import 'package:flutter/material.dart';
import '../../widgets/page_title/page_title.dart';

class SingleCollectionView extends StatelessWidget {
  const SingleCollectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          PageTitle(title: "my profile"),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
