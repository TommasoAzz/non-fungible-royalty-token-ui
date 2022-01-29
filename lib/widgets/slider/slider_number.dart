import 'package:flutter/material.dart';

class SliderNumber extends StatefulWidget {
  final String title;
  final void Function(double) saveValue;

  const SliderNumber({
    Key? key,
    required this.saveValue,
    required this.title,
  }) : super(key: key);

  @override
  State<SliderNumber> createState() => _SliderNumberState();
}

class _SliderNumberState extends State<SliderNumber> {
  double _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
        Slider(
          value: _currentValue,
          min: 0,
          max: 100,
          divisions: 10,
          onChanged: (value) {
            widget.saveValue(value);
            setState(() => _currentValue = value);
          },
        ),
        Text(
          'Current value: ${_currentValue.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
