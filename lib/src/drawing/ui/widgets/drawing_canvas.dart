import 'package:flutter/material.dart';
import 'package:flutter_drawio/src/drawing/drawing_barrel.dart';
import 'package:flutter_drawio/src/utils/utils_barrel.dart';

part 'canvases/primary_canvas.dart';

part 'canvases/secondary_canvas.dart';

class DrawingCanvas extends StatefulWidget {
  final DrawingController controller;
  final Size size;

  const DrawingCanvas({
    Key? key,
    required this.controller,
    required this.size,
  }) : super(key: key);

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  late final double yDrawingBounds = widget.size.height;
  late final double xDrawingBounds = widget.size.width;

  DrawingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: yDrawingBounds,
      width: xDrawingBounds,
      child: Stack(
        children: [
          SizedBox(
            height: yDrawingBounds,
            width: xDrawingBounds,
            child: _SecondaryCanvas(
              controller: controller,
              lineDrawingPainter: const LineDrawingPainter(),
              shapeDrawingPainter: const ShapePainter(),
              sketchDrawingPainter: const SketchPainter(),
            ),
          ),
          SizedBox(
            height: yDrawingBounds,
            width: xDrawingBounds,
            child: _PrimaryCanvas(
              controller: controller,
              lineDrawingPainter: const LineDrawingPainter(),
              shapeDrawingPainter: const ShapePainter(),
              sketchDrawingPainter: const SketchPainter(),
            ),
          ),
          GestureDetector(
            onPanStart: panStart,
            onPanEnd: (details) {
              if (controller.drawingMode == DrawingMode.erase) return;
              panEnd(details);
            },
            onPanUpdate: panUpdate,
          ),
        ],
      ),
    );
  }

  void changeColor(Color color) {
    controller.changeColor(color);
  }

  final ValueNotifier<int?> dragChangeNotifier = ValueNotifier<int?>(null);

  int computeDurationDifference(Duration duration) {
    final int durationDifference = dragChangeNotifier.value == null
        ? 0
        : duration.inMilliseconds - dragChangeNotifier.value!;
    dragChangeNotifier.value = duration.inMilliseconds;
    return durationDifference;
  }

  double computeDragSpeed(double distance, Duration duration) {
    final int time = computeDurationDifference(duration);
    return time == 0 ? 0 : distance / time;
  }

  PointDouble pointDoubleFromOffset(Offset offset) {
    return PointDouble(offset.dx, offset.dy);
  }

  void panStart(DragStartDetails details) {
    final DrawingDelta delta = DrawingDelta(
      point: PointDouble(
        details.localPosition.dx,
        details.localPosition.dy,
      ),
      operation: DrawingOperation.start,
    );

    controller.draw(delta);
  }

  void panEnd(DragEndDetails details) {
    final DrawingDelta delta = DrawingDelta(
      point: controller.drawings.isEmpty
          ? const PointDouble(0, 0)
          : controller.drawings.last.deltas.last.point,
      operation: DrawingOperation.end,
    );

    controller.draw(delta);
  }

  bool isOutOfBounds(Offset offset) {
    return (offset.dx < 0 || offset.dx > xDrawingBounds) ||
        (offset.dy < 0 || offset.dy > yDrawingBounds);
  }

  void panUpdate(DragUpdateDetails details) {
    if (isOutOfBounds(details.localPosition)) return;

    final DrawingDelta delta = DrawingDelta(
      point: pointDoubleFromOffset(details.localPosition),
      operation: DrawingOperation.neutral,
    );

    controller.draw(delta);
  }

  @override
  void initState() {
    if (!controller.initialized) controller.initialize();
    super.initState();
  }
}
