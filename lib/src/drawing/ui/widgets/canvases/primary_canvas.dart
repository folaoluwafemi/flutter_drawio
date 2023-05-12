part of '../drawing_canvas.dart';

class _PrimaryCanvas extends StatelessWidget {
  final DrawingController controller;
  final DrawingPainter<ShapeDrawing> shapeDrawingPainter;
  final DrawingPainter<SketchDrawing> sketchDrawingPainter;

  const _PrimaryCanvas({
    Key? key,
    required this.controller,
    required this.shapeDrawingPainter,
    required this.sketchDrawingPainter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierBuilder<DrawingController>(
      listenable: controller,
      buildWhen: (previous, next) =>
          previous?.currentlyActiveDrawing == next.currentlyActiveDrawing,
      builder: (context, value) => value.currentlyActiveDrawing == null
          ? const SizedBox.shrink()
          : CustomPaint(
              painter: PrimaryDrawingsPainter(
                shapeDrawingPainter: shapeDrawingPainter,
                sketchDrawingPainter: sketchDrawingPainter,
                drawing: value.currentlyActiveDrawing!,
              ),
            ),
    );
  }
}
