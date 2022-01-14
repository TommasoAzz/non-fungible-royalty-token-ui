import 'package:flutter/material.dart';
import '../../widgets/Collections/collections.dart';

class CollectionsView extends StatelessWidget {
  const CollectionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GridView.count(
      primary: false,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 20,
      mainAxisSpacing: 10,
      crossAxisCount: 4,
      children: <Widget>[
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 100),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "3"], color: 200),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 300),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 400),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 500),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 600),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 700),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 800),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 900),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 800),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 700),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 600),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 500),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 400),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 300),
        const Collection(
            text: ["Name", "NAM", "0xgfhyerb73qfggsd8je", "5"], color: 200),
      ],
    ));
  }
}
