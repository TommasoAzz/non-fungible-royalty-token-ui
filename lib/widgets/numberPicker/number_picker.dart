import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class PickNumber extends StatefulWidget {
  @override
  _PickNumberState createState() => _PickNumberState();
}

class _PickNumberState extends State<PickNumber> {
  int _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 100,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
        Text('Current value: $_currentValue'),
      ],
    );
  }
}
