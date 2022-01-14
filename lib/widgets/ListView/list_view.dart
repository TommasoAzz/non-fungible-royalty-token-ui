import 'package:flutter/material.dart';

final List<int> colorCodes = <int>[600, 500, 100];

class ListsView extends StatelessWidget {
  const ListsView({Key? key, required this.entries, required this.colorCodes})
      : super(key: key);
  final List<String> entries;
  final List<int> colorCodes;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.all(5),
                color: Colors.blue[colorCodes[index]],
                child: Center(child: Text('Entry ${entries[index]}')),
              );
            }));
  }
}
