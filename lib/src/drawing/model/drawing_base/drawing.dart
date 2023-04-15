import 'package:flutter_drawio/src/drawing/drawing_barrel.dart';
import 'package:flutter_drawio/src/utils/utils_barrel.dart';
import 'package:equatable/equatable.dart';

part 'actionables/drawing_mode.dart';

part 'drawing_type.dart';

abstract class Drawing with EquatableMixin {
  final List<DrawingDelta> deltas;
  final DrawingMetadata? metadata;

  const Drawing({
    required this.deltas,
    this.metadata,
  });

  Drawing copyWith({
    List<DrawingDelta>? deltas,
    DrawingMetadata? metadata,
  });

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
      'Shape cannot be null when constructing a [ShapeDrawing] object',
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

  Map<String, dynamic> toMap();

  factory Drawing.fromMap(Map<String, dynamic> map) {
    final DrawingType type =
        DrawingType.values[int.parse(map['type'].toString())];

    switch (type) {
      case DrawingType.shape:
        return ShapeDrawing.fromMap(map);
      case DrawingType.sketch:
        return SketchDrawing.fromMap(map);
      case DrawingType.line:
        // TODO: Handle this case.
        break;
    }
    //TODO: Change
    return SketchDrawing.fromMap(map);
  }
}
