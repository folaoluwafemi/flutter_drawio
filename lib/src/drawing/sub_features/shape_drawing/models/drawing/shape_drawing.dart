import 'package:flutter_drawio/src/drawing/drawing_barrel.dart'
    show Drawing, DrawingDelta, DrawingMetadata, Shape;
import 'package:flutter_drawio/src/drawing/model/drawing_model_barrel.dart'
    show Drawing, DrawingDelta, DrawingMetadata, DrawingType;

/// This class is used to represent a [Drawing] of type [DrawingType.shape].
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': DrawingType.shape.index,
      'shape': shape.index,
      'deltas': deltas.map((e) => e.toMap()).toList(),
      'metadata': metadata?.toMap(),
    };
  }

  factory ShapeDrawing.fromMap(Map<String, dynamic> map) {
    return ShapeDrawing(
      shape: Shape.values[(map['shape'] as int)],
      deltas: (map['deltas'] as List)
          .cast<Map>()
          .map<DrawingDelta>((e) => DrawingDelta.fromMap(e.cast()))
          .toList(),
      metadata: map['metadata'] == null
          ? null
          : DrawingMetadata.fromMap((map['metadata'] as Map).cast()),
    );
  }
}
