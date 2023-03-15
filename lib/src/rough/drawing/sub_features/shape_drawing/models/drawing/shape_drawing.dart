import 'package:flutter_drawer/src/rough/drawing/drawing_barrel.dart'
    show Drawing, DrawingDelta, DrawingMetadata, Shape, ShapeDrawing;

class ShapeDrawing extends Drawing {
  final Shape shape;

  ShapeDrawing({
    required this.shape,
    required super.deltas,
    super.metadata,
  });

  @override
  ShapeDrawing copyWith({
    final Shape? shape,
    List<DrawingDelta>? deltas,
    DrawingMetadata? metadata,
  }) {
    return ShapeDrawing(
      shape: shape ?? this.shape,
      deltas: deltas ?? this.deltas,
      metadata: metadata ?? this.metadata,
    );
  }
}
