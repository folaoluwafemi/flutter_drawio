import 'package:flutter/material.dart';
import 'package:flutter_drawio/src/drawing/drawing_barrel.dart';

base class LineDrawingPainter extends DrawingPainter<LineDrawing> {
  const LineDrawingPainter();

  @override
  void paintDrawing(Canvas canvas, Size size, LineDrawing drawing) {
    if (drawing.deltas.length == 1) return;

    final Paint paint = Paint()
      ..color = drawing.metadata?.color ?? Colors.black
      ..strokeWidth = drawing.metadata?.strokeWidth ?? 4
      ..style = PaintingStyle.stroke;

    final Path path = Path()..moveTo(0, 0);

    final DrawingDelta firstDelta = drawing.deltas.firstWhere(
      (element) => element.operation == DrawingOperation.start,
    );
    final DrawingDelta latestDelta = drawing.deltas.lastWhere(
      (element) => element.operation == DrawingOperation.neutral,
    );

    path
      ..moveTo(firstDelta.point.x, firstDelta.point.y)
      ..lineTo(latestDelta.point.x, latestDelta.point.y);

    canvas.drawPath(path, paint);
  }
}
