import 'package:flutter/material.dart';

enum ChangeColor {
  red(Colors.red),
  green(Colors.green),
  blue(Colors.blue),
  ;

  final Color color;

  const ChangeColor(this.color);
}
