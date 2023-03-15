import 'package:flutter_drawer/src/rough/drawing/drawing_barrel.dart';

class SketchDrawing extends Drawing {
  SketchDrawing({
    required super.deltas,
    super.metadata,
  });

  @override
  SketchDrawing copyWith({
    List<DrawingDelta>? deltas,
    DrawingMetadata? metadata,
  }) {
    return SketchDrawing(
      deltas: deltas ?? this.deltas,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return '''\n
    SketchDrawing{
      deltas: $deltas,
      metadata: $metadata,
    }''';
  }
}
