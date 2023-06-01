import 'package:flutter/material.dart';
import 'package:flutter_drawio/src/drawing/drawing_barrel.dart';

/// This is the base class for all [DrawingPainter]s.
///
/// if you wish to add a painter to the [DrawingsPainter] you must extend this class.
abstract base class DrawingPainter<T extends Drawing> {
  const DrawingPainter();

  void paintDrawing(Canvas canvas, Size size, T drawing);
}
