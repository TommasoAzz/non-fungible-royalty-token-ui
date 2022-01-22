import 'dart:math';

import 'package:flutter/material.dart';
import '../../widgets/page_title/page_title.dart';
import '../../widgets/collections/collections.dart';

class CollectionsContentMobile extends StatelessWidget {
  const CollectionsContentMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const PageTitle(title: "collections"),
        SizedBox(
          width: 212,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: 16,
            itemBuilder: (context, index) => Collection(
              text: const ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
              color: Random.secure().nextInt(9) * 100 + 100,
            ),
          ),
        ),
      ]),
    );
  }
}
