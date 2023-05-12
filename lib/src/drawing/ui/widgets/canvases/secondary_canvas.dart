part of '../drawing_canvas.dart';

class _SecondaryCanvas extends StatelessWidget {
  final DrawingController controller;
  final DrawingPainter<ShapeDrawing> shapeDrawingPainter;
  final DrawingPainter<SketchDrawing> sketchDrawingPainter;

  const _SecondaryCanvas({
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
      // ignore: invalid_use_of_protected_member
      previous?.mutableDrawing != next.mutableDrawing,
      key: UniqueKey(),
      builder: (_, controller) {
        return CustomPaint(
          key: const ValueKey('DrawingsCustomPaintKey'),
          painter: SecondaryDrawingsPainter(
            shapeDrawingPainter: shapeDrawingPainter,
            sketchDrawingPainter: sketchDrawingPainter,
            drawings: controller.drawings,
          ),
        );
      },
    );
  }
}
