import 'dart:math';

import 'package:flutter/material.dart';
import '../../widgets/collections/collections.dart';

class CollectionsContentMobile extends StatelessWidget {
  const CollectionsContentMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO(dominego): Make a square item.
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          width: 220,
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
