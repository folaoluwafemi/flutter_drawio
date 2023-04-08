import 'package:flutter/material.dart';
import 'package:nobook/src/global/ui/ui_barrel.dart';

enum ChangeColor {
  red(AppColors.red500),
  green(AppColors.green800),
  blue(AppColors.blue500),
  ;

  final Color color;

  const ChangeColor(this.color);
}
