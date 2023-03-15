import 'package:flutter/cupertino.dart';
import 'package:flutter_drawer/src/rough/drawing/drawing_barrel.dart';

class DrawingsPainter extends CustomPainter {
  final List<Drawing> drawings;
  final DrawingPainter<ShapeDrawing> shapeDrawingPainter;
  final DrawingPainter<SketchDrawing> sketchDrawingPainter;

  const DrawingsPainter({
    required this.shapeDrawingPainter,
    required this.sketchDrawingPainter,
    required this.drawings,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final Drawing drawing in drawings) {
      switch (drawing.runtimeType) {
        case ShapeDrawing:
          shapeDrawingPainter.paintDrawing(
            canvas,
            size,
            drawing as ShapeDrawing,
          );
          break;
        case SketchDrawing:
          sketchDrawingPainter.paintDrawing(
            canvas,
            size,
            drawing as SketchDrawing,
          );
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is DrawingsPainter && oldDelegate.drawings != drawings;
  }
}
