import 'package:equatable/equatable.dart';
import 'package:flutter_drawer/src/rough/drawing/drawing_barrel.dart';

part 'actionables/drawing_mode.dart';

class Drawing with EquatableMixin {
  final List<DrawingDelta> deltas;
  final DrawingMetadata? metadata;

  const Drawing({
    required this.deltas,
    this.metadata,
  });

  Drawing copyWith({
    List<DrawingDelta>? deltas,
    DrawingMetadata? metadata,
  }) {
    return Drawing(
      deltas: deltas ?? this.deltas,
      metadata: metadata ?? this.metadata,
    );
  }

  static Drawing drawingType<T extends Drawing>({
    required List<DrawingDelta> deltas,
    required DrawingMetadata? metadata,
    Shape? shape,
  }) {
    assert(
      () {
        if (T == ShapeDrawing) {
          return shape != null;
        }
        return true;
      }(),
      "Shape cannot be null when constructing a [ShapeDrawing] object",
    );
    switch (T) {
      case ShapeDrawing:
        return ShapeDrawing(
          shape: shape!,
          deltas: deltas,
          metadata: metadata,
        );
      default:
        return SketchDrawing(
          deltas: deltas,
          metadata: metadata,
        );
    }
  }

  @override
  List<Object?> get props => [metadata, ...deltas];
}
