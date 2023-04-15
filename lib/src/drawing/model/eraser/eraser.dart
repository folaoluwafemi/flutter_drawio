import 'dart:ui';

import 'package:flutter_drawio/src/drawing/drawing_barrel.dart';
import 'package:flutter_drawio/src/utils/utils_barrel.dart';

part 'erase_mode.dart';

part 'region.dart';

/// This class carries data and methods/logic for erasing a drawing.
///
class Eraser {
  final Region region;
  final EraseMode mode;

  const Eraser({
    required this.region,
    required this.mode,
  });

  Eraser copyWith({
    Region? region,
    EraseMode? mode,
  }) {
    return Eraser(
      region: region ?? this.region,
      mode: mode ?? this.mode,
    );
  }

  /// a pure function that splits a list of [DrawingDelta]s into a list of two or more separate [Drawing]s by the [region] of the [Eraser] combined appropriately with the [defaultMetadata].
  List<Drawing> splitDrawingDeltaToDrawings<T extends Drawing>(
    final Type drawingType,
    List<DrawingDelta> deltas, [
    DrawingMetadata? defaultMetadata,
  ]) {
    deltas = List.from(deltas);
    final List<Drawing> drawings = [];

    bool currentlyAddingDrawing = false;
    for (final DrawingDelta delta in deltas) {
      if (delta.operation == DrawingOperation.start) {
        currentlyAddingDrawing = true;
        Drawing? drawing;
        switch (drawingType) {
          case ShapeDrawing:

            /// Shapes cannot be erased by area
            break;
          case SketchDrawing:
            drawing = SketchDrawing(
              deltas: [delta],
              metadata: defaultMetadata ?? delta.metadata,
            );
            break;
        }

        drawings.add(drawing!);
        continue;
      }
      if (currentlyAddingDrawing) {
        drawings.last.deltas.add(delta);
      }
      if (delta.operation == DrawingOperation.end) {
        currentlyAddingDrawing = false;
      }
    }
    return drawings;
  }

  /// This is a pure function that removes a point delta from a list of [Drawing]s
  Drawings eraseDrawingAtSpecific(PointDouble point, Drawings drawings) {
    drawings = List.from(drawings);

    drawings.removeWhere(
      (element) => element.deltas.containsWhere(
        (value) => value.point == point,
      ),
    );
    return drawings;
  }

  bool _shapeDrawingEraseTest(ShapeDrawing shape, Region region) {
    if (shape.deltas.length <= 1) return true;
    final PointDouble firstPoint = shape.deltas.first.point;
    final PointDouble secondPoint = shape.deltas.last.point;
    final Rect rect = Rect.fromPoints(
      firstPoint.toOffset,
      secondPoint.toOffset,
    );

    return rect.contains(region.maxPoint.toOffset) ||
        rect.contains(region.minPoint.toOffset);
  }

  /// This is a pure function that removes a drawing from a list of [Drawing]s
  Drawings eraseDrawingFrom(Drawings drawings) {
    final Region region = this.region;
    drawings = List.from(drawings);

    drawings.removeWhere(
      (drawing) {
        if (drawing is ShapeDrawing) {
          return _shapeDrawingEraseTest(drawing, region);
        }

        return drawing.deltas.containsWhere(
          (value) => region.containsPoint(value.point),
        );
      },
    );

    return drawings;
  }

  /// This is a pure function that removes the area in [region] from [drawings]
  Drawings eraseAreaFrom(Drawings drawings) {
    final Region region = this.region;

    drawings = List.from(drawings);

    Drawing? drawingToBeErased;

    for (final Drawing drawing in drawings) {
      if (drawing.deltas.containsWhere(
        (value) => region.containsPoint(value.point),
      )) {
        drawingToBeErased = drawing;
        break;
      }
    }
    if (drawingToBeErased == null) return drawings;

    if (drawingToBeErased is ShapeDrawing) {
      return eraseShapeIfInRegion(drawings, drawingToBeErased, region);
    }

    final Drawing drawingTobeErasedCopy = drawingToBeErased;

    final DrawingDelta erasedDelta = drawingToBeErased.deltas
        .firstWhere((element) => region.containsPoint(element.point));

    final int erasedDeltaIndex = drawingToBeErased.deltas.indexOf(erasedDelta);

    if (drawingToBeErased.deltas.isFirst(erasedDelta)) {
      if (drawingToBeErased.deltas.length == 1) {
        drawingToBeErased.deltas.clear();
      } else {
        drawingToBeErased.deltas[1] = drawingToBeErased.deltas[1].copyWith(
          operation: DrawingOperation.start,
        );
        drawingToBeErased.deltas.removeAt(0);
      }
      drawings.replace(drawingTobeErasedCopy, [drawingToBeErased]);
    } else if (drawingToBeErased.deltas.isLast(erasedDelta)) {
      final int length = drawingToBeErased.deltas.length;
      drawingToBeErased.deltas[length - 2] = drawingToBeErased
          .deltas[length - 2]
          .copyWith(operation: DrawingOperation.end);
      drawingToBeErased.deltas.removeLast();
      drawings.replace(drawingTobeErasedCopy, [drawingToBeErased]);
    } else {
      drawingToBeErased.deltas[erasedDeltaIndex - 1] = drawingToBeErased
          .deltas[erasedDeltaIndex - 1]
          .copyWith(operation: DrawingOperation.end);

      drawingToBeErased.deltas[erasedDeltaIndex + 1] = drawingToBeErased
          .deltas[erasedDeltaIndex + 1]
          .copyWith(operation: DrawingOperation.start);

      drawingToBeErased.deltas.removeAt(erasedDeltaIndex);

      final List<Drawing> modifiedDrawings = splitDrawingDeltaToDrawings(
        drawingToBeErased.runtimeType,
        drawingToBeErased.deltas,
        drawingToBeErased.metadata,
      );
      drawings.replace(drawingTobeErasedCopy, [...modifiedDrawings]);
    }

    return drawings;
  }

  /// This is a pure function that removes a shape from a list of [Drawing]s if it's exists within [region]
  Drawings eraseShapeIfInRegion(
    Drawings drawings,
    ShapeDrawing drawingTobeErased,
    Region eraseRegion,
  ) {
    return drawings
      ..removeWhere(
        (element) => _shapeDrawingEraseTest(drawingTobeErased, eraseRegion),
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'region': region.toMap(),
      'mode': mode.toSerializerString,
    };
  }

  factory Eraser.fromMap(Map<String, dynamic> map) {
    return Eraser(
      region: Region.fromMap((map['region'] as Map).cast()),
      mode: EraseMode.fromString(map['mode']),
    );
  }
}
