import 'package:flutter_drawer/src/drawing/drawing_barrel.dart';

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

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': DrawingType.sketch.index,
      'deltas': deltas.map((e) => e.toMap()).toList(),
      'metadata': metadata?.toMap(),
    };
  }

  factory SketchDrawing.fromMap(Map<String, dynamic> map) {
    return SketchDrawing(
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
