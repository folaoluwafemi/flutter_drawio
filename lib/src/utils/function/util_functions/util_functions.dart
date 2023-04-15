import 'package:flutter/material.dart';
import 'package:flutter_drawer/src/utils/utils_barrel.dart';

abstract class UtilFunctions {
  static bool listEqual(List list1, List list2) {
    if (list1.length != list2.length) return false;
    final int listLength = list1.length;
    for (int i = 0; i < listLength; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  static Color interpolateColors(double value, List<Color> colors) {
    assert(value >= 0 || value <= 1, 'value must be between 0 and 1');

    final int colorListLength = colors.length - 1;

    final int maxExpectedIndex = (colorListLength * value).ceil();
    final int minExpectedIndex = (colorListLength * value).floor();

    final Color minColor = colors[minExpectedIndex];
    final Color maxColor = colors[maxExpectedIndex];

    return Color.lerp(minColor, maxColor, value)!;
  }

  static PointDouble pointDoubleFromMap(Map<String, dynamic> map) {
    return PointDouble(
      (map['x'] as num).toDouble(),
      (map['y'] as num).toDouble(),
    );
  }

  static double extrapolateColors(Color value, List<Color> colors) {
    int difference = 100000000;
    int colorIndex = 0;

    for (final Color color in colors) {
      final int temp = (color.value - value.value).abs();
      if (temp < difference) {
        difference = temp;
        colorIndex = colors.indexOf(color);
      }
    }

    return colorIndex / (colors.length - 1);
  }
}
