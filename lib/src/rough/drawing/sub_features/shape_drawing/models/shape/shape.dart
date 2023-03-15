import 'package:flutter/material.dart';

import 'package:flutter_drawer/src/utils/utils_barrel.dart';

enum Shape {
  rectangle(Icons.rectangle_outlined, VectorAssets.rectangleIcon),
  circle(Icons.circle_outlined, VectorAssets.circleIcon),
  triangle(Icons.change_history, VectorAssets.triangleIcon),
  star(Icons.star_border, VectorAssets.starIcon);

  final IconData iconData;
  final String assetPath;

  const Shape(this.iconData, this.assetPath);
}
