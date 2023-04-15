import 'package:flutter/material.dart';
import 'package:flutter_drawio/src/drawing/drawing_barrel.dart';
import 'package:flutter_drawio/src/utils/utils_barrel.dart';

class SketchPainter extends DrawingPainter<SketchDrawing> {
  const SketchPainter();

  @override
  void paintDrawing(Canvas canvas, Size size, SketchDrawing drawing) {
    final Paint paint = Paint()
      ..color = drawing.metadata?.color ?? Colors.black
      ..strokeWidth = drawing.metadata?.strokeWidth ?? 4
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(0, 0);

    for (final DrawingDelta drawingDelta in drawing.deltas) {
      paintDelta(
        drawing: drawing,
        drawingDelta: drawingDelta,
        paint: paint,
        path: path,
        canvas: canvas,
        size: size,
      );
    }
    canvas.drawPath(path, paint);
  }

  void paintDelta({
    required Drawing drawing,
    required DrawingDelta drawingDelta,
    required Paint paint,
    required Path path,
    required Canvas canvas,
    required Size size,
  }) {
    switch (drawingDelta.operation) {
      case DrawingOperation.start:
        paint.color = drawingDelta.metadata?.color ??
            drawing.metadata?.color ??
            paint.color;
        paint.strokeWidth = drawingDelta.metadata?.strokeWidth ??
            drawing.metadata?.strokeWidth ??
            paint.strokeWidth;

        path.moveTo(drawingDelta.point.x, drawingDelta.point.y);
        break;
      case DrawingOperation.end:
        // path.reset();
        // path.lineTo(drawingDelta.point.x, drawingDelta.point.y);
        break;
      case DrawingOperation.neutral:
        {
          paint.color = drawingDelta.metadata?.color ??
              drawing.metadata?.color ??
              paint.color;
          paint.strokeWidth = drawingDelta.metadata?.strokeWidth ??
              drawing.metadata?.strokeWidth ??
              paint.strokeWidth;

          if (drawing.deltas.isFirst(drawingDelta)) break;

          // final PointDouble previousPoint =
          //     drawing.deltas[drawing.deltas.indexOf(drawingDelta) - 1].point;
          // canvas.drawLine(
          //   previousPoint.toOffset,
          //   drawingDelta.point.toOffset,
          //   paint,
          // );

          path.lineTo(drawingDelta.point.x, drawingDelta.point.y);

          break;
        }
    }
  }
}
