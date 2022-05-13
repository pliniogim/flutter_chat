import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback pressed;

  const RoundedButton(
      {Key? key,
      required this.color,
      required this.title,
      required this.pressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: pressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}