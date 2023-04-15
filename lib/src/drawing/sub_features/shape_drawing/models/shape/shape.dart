import 'package:flutter_drawio/src/utils/utils_barrel.dart';

/// This holds the currently supported shape drawing types.
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
