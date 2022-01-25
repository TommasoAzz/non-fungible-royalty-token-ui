import 'package:flutter/material.dart';

class SliderNumber extends StatefulWidget {
  const SliderNumber({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SliderNumber> createState() => _SliderNumberState();
}

class _SliderNumberState extends State<SliderNumber> {
  double _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Column(
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
            onChanged: (value) => setState(() => _currentValue = value),
          ),
          Text(
            'Current value: ${_currentValue.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
