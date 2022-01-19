import 'package:flutter/material.dart';
import '../../widgets/collections/collections.dart';

class CollectionsContentTabletDesktop extends StatelessWidget {
  const CollectionsContentTabletDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          "COLLECTION",
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Expanded(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: const <Widget>[
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 100),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "3"],
                  color: 200),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 300),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 400),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 500),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 600),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 700),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 800),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 900),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 800),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 700),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 600),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 500),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 400),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 300),
              Collection(
                  text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"],
                  color: 200),
            ],
          ),
        ),
      ],
    );
  }
}