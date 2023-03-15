import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_drawer/src/rough/drawing/drawing_barrel.dart';
import 'package:flutter_drawer/src/utils/utils_barrel.dart';

extension DrawingsExentension on Drawings {
  bool containsDrawingAt(PointDouble pointDelta) {
    final List<Drawing> drawings = List.from(this);

    for (final Drawing drawing in drawings) {
      if (drawing.deltas.containsWhere((value) => value.point == pointDelta)) {
        return true;
      }
    }
    return false;
  }
}

extension PointDoubleExtension on PointDouble {
  Offset get toOffset => Offset(x, y);

  PointDouble center(PointDouble p2) {
    final double midX = ((x + p2.x) / 2);
    final double midY = ((y + p2.y) / 2);

    return PointDouble(midX, midY);
  }
}

extension SizeExt on Size {
  double get magnitude {
    return math.sqrt((height * height) + (width * width));
  }
}

extension OffsetExtension on Offset {
  Offset copyWith({
    double? dx,
    double? dy,
  }) {
    return Offset(
      dx ?? this.dx,
      dy ?? this.dy,
    );
  }

  PointDouble get point => PointDouble(dx, dy);
}
