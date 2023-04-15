import 'package:flutter/material.dart';
import 'package:drawer/src/drawing/drawing_barrel.dart';

abstract class DrawingPainter<T extends Drawing> {
  const DrawingPainter();

  void paintDrawing(Canvas canvas, Size size, T drawing);
}
