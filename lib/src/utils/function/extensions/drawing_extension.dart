part of 'extensions.dart';

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

  Map<String, dynamic> toMap() {
    return {'x': x, 'y': y};
  }
}



