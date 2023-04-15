import 'package:flutter_drawer/src/utils/utils_barrel.dart';

enum Shape {
  rectangle(VectorAssets.rectangleIcon),
  circle(VectorAssets.circleIcon),
  triangle(VectorAssets.triangleIcon),
  star(VectorAssets.starIcon);

  final String assetPath;

  const Shape(this.assetPath);

  factory Shape.fromString(String data) {
    data = data.cleanLower;

    return Shape.values.firstWhere(
      (element) => element.name.cleanLower == data,
    );
  }

  String get toSerializerString => name;
}
