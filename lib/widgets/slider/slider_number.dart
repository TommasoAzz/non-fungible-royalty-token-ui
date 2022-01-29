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
  // double _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return FormField<double>(
      initialValue: 0,
      builder: (fieldState) => InputDecorator(
        decoration: InputDecoration(
          labelText: widget.title,
          labelStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          border: InputBorder.none,
        ),
        child: Slider(
          value: fieldState.value!,
          label: 'Current value: ${fieldState.value!.toStringAsFixed(0)}',
          min: 0,
          max: 100,
          divisions: 10,
          onChanged: (value) {
            widget.saveValue(value);
            setState(() {
              // _currentValue = value;
              fieldState.didChange(value);
            });
          },
        ),
      ),
    );
  }
}
