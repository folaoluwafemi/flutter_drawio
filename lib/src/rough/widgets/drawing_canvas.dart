import 'package:flutter/material.dart';
import 'package:flutter_drawer/src/drawing/drawing_barrel.dart';
import 'package:flutter_drawer/src/global/ui/ui_barrel.dart';

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
  late final double drawingBoundsVertical = widget.size.height;
  late final double drawingBoundsHorizontal = widget.size.width;

  DrawingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: drawingBoundsVertical,
      width: drawingBoundsHorizontal,
      child: Stack(
        children: [
          SizedBox(
            height: drawingBoundsVertical,
            width: drawingBoundsHorizontal,
            child: ChangeNotifierBuilder<DrawingController>(
              listenable: controller,
              key: UniqueKey(),
              builder: (_, controller) {
                return CustomPaint(
                  key: const ValueKey('DrawingsCustomPaintKey'),
                  painter: DrawingsPainter(
                    shapeDrawingPainter: const ShapePainter(),
                    sketchDrawingPainter: const SketchPainter(),
                    drawings: controller.drawings,
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onPanStart: panStart,
            onPanEnd: (details) {
              details.velocity.pixelsPerSecond;
              // if (erasingNotifier.value) return;
              if (controller.drawingMode == DrawingMode.erase) return;
              panEnd(details);
            },
            onForcePressStart: (details) {},
            onForcePressUpdate: (details) {
              details.pressure;
              print('force pressure: ${details.pressure}');
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
    return (offset.dx < 0 || offset.dx > drawingBoundsHorizontal) ||
        (offset.dy < 0 || offset.dy > drawingBoundsVertical);
  }

  void panUpdate(DragUpdateDetails details) {
    if (isOutOfBounds(details.localPosition)) return;

    final double speed = details.sourceTimeStamp != null
        ? computeDragSpeed(details.delta.distance, details.sourceTimeStamp!)
        : 0;

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

  @override
  void dispose() {
    super.dispose();
  }
}
