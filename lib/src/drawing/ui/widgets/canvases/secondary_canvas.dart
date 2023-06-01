part of '../drawing_canvas.dart';

class _SecondaryCanvas extends StatelessWidget {
  final DrawingController controller;
  final DrawingPainter<ShapeDrawing> shapeDrawingPainter;
  final DrawingPainter<SketchDrawing> sketchDrawingPainter;
  final DrawingPainter<LineDrawing> lineDrawingPainter;

  const _SecondaryCanvas({
    Key? key,
    required this.controller,
    required this.shapeDrawingPainter,
    required this.sketchDrawingPainter,
    required this.lineDrawingPainter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierBuilder<DrawingController>(
      listenable: controller,
      buildWhen: (previous, next) =>
          // ignore: invalid_use_of_protected_member
          previous?.mutableDrawing == next.mutableDrawing,
      key: UniqueKey(),
      builder: (_, controller) {
        return CustomPaint(
          key: const ValueKey('DrawingsCustomPaintKey'),
          painter: SecondaryDrawingsPainter(
            shapeDrawingPainter: shapeDrawingPainter,
            sketchDrawingPainter: sketchDrawingPainter,
            lineDrawingPainter: lineDrawingPainter,
            drawings: controller.drawings,
          ),
        );
      },
    );
  }
}
