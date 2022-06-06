import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign align;
  final Color color;
  final TextDecoration? decoration;

  const MyText(
    this.text, {
    Key? key,
    this.size = 13,
    this.align = TextAlign.start,
    this.color = Colors.black,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: size,
        decoration: decoration,
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
