import 'package:flutter_drawio/src/drawing/drawing_barrel.dart';

/// This class is used to represent a [Drawing] of type [DrawingType.line].
base class LineDrawing extends Drawing {
  LineDrawing({
    required super.deltas,
    super.metadata,
  });

  factory LineDrawing.fromMap(Map<String, dynamic> map) {
    return LineDrawing(
      deltas: (map['deltas'] as List)
          .cast<Map>()
          .map<DrawingDelta>((e) => DrawingDelta.fromMap(e.cast()))
          .toList(),
      metadata: map['metadata'] == null
          ? null
          : DrawingMetadata.fromMap((map['metadata'] as Map).cast()),
    );
  }

  @override
  Drawing copyWith({
    List<DrawingDelta>? deltas,
    DrawingMetadata? metadata,
  }) {
    return LineDrawing(
      deltas: deltas ?? this.deltas,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return '''\n
    LineDrawing{
      deltas: $deltas,
      metadata: $metadata,
    }''';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': DrawingType.line.index,
      'deltas': deltas.map((e) => e.toMap()).toList(),
      'metadata': metadata?.toMap(),
    };
  }
}
