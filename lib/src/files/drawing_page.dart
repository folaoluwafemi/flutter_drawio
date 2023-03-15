import 'package:flutter/material.dart';
import 'package:flutter_drawer/src/files/model/document_editor_model.dart';
import 'package:flutter_drawer/src/files/model/drawing_editing_delta.dart';
import 'package:flutter_drawer/src/utils/function/extensions/extensions.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NotePageState();
}

class _NotePageState extends State<DrawingPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    const double regionRadius = 5;

    return Material(
      child: Center(
        child: Column(
          children: [
            FilledButton.tonal(
              onPressed: () {
                drawingsNotifier.value = List<Drawing>.empty(growable: true);
              },
              child: const Text('clear'),
            ),
            ValueListenableBuilder<List<Drawing>>(
              valueListenable: drawingsNotifier,
              builder: (_, deltas, __) {
                return ValueListenableBuilder<bool>(
                  valueListenable: erasingNotifier,
                  builder: (_, erasing, __) {
                    return FilledButton.tonal(
                      onPressed: (deltas.isEmpty && !erasing)
                          ? null
                          : () {
                              erasingNotifier.value = !erasingNotifier.value;
                            },
                      child: Text(
                        erasing ? 'stop erasing' : 'start erase',
                      ),
                    );
                  },
                );
              },
            ),
            20.boxHeight,
            Container(
              color: Colors.orange.withOpacity(0.4),
              width: 600,
              height: 600,
              child: Stack(
                children: [
                  SizedBox.square(
                    dimension: 600,
                    child: ValueListenableBuilder<List<Drawing>>(
                      valueListenable: drawingsNotifier,
                      builder: (_, deltas, __) {
                        return CustomPaint(
                          painter: DrawingPainter(
                            drawings: deltas,
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onPanStart: (details) {
                      final Region region = Region(
                        centre: pointDoubleFromOffset(details.localPosition),
                        radius: regionRadius,
                      );
                      erasingNotifier.value
                          ?
                          // eraseDelta(
                          // pointDoubleFromOffset(details.localPosition),
                          // )
                          eraseDrawingInRegion(region)
                          : panStart(details);
                    },
                    onPanEnd: (details) {
                      if (erasingNotifier.value) return;
                      panEnd(details);
                    },
                    onPanUpdate: (details) {
                      final Region region = Region(
                        centre: pointDoubleFromOffset(details.localPosition),
                        radius: regionRadius,
                      );
                      erasingNotifier.value
                          ? eraseDrawingInRegion(region)

                          // eraseDelta(
                          //   pointDoubleFromOffset(details.localPosition),
                          // )
                          : panUpdate(details);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final ValueNotifier<bool> erasingNotifier = ValueNotifier<bool>(false);

  void eraseDrawingAt(PointDouble pointDelta) {
    final List<Drawing> drawings = List.from(drawingsNotifier.value);

    drawings.removeWhere(
      (element) => element.deltas.containsWhere(
        (value) => value.point == pointDelta,
      ),
    );
  }

  void eraseDrawingInRegion(Region region) {
    final List<Drawing> drawings = List.from(
      drawingsNotifier.value,
    );

    drawings.removeWhere(
      (element) => element.deltas.containsWhere(
        (value) => region.containsPoint(value.point),
      ),
    );

    ///
    drawingsNotifier.value = List.from(drawings);
  }

  bool containsDrawingAt(PointDouble pointDelta) {
    final List<Drawing> drawings = List.from(drawingsNotifier.value);

    for (final Drawing drawing in drawings) {
      if (drawing.deltas.containsWhere((value) => value.point == pointDelta)) {
        return true;
      }
    }
    return false;
  }

  void removeLastDrawing() {
    final List<Drawing> drawings = List.from(drawingsNotifier.value);
    print('all drawings: $drawings');
    drawings.removeLast();

    drawingsNotifier.value = List.from(drawings);
  }

  final ValueNotifier<List<Drawing>> drawingsNotifier =
      ValueNotifier<List<Drawing>>([]);

  @override
  void dispose() {
    erasingNotifier.dispose();
    drawingsNotifier.dispose();
    super.dispose();
  }

  PointDouble pointDoubleFromOffset(Offset offset) {
    return PointDouble(offset.dx, offset.dy);
  }

  void addDeltaToDrawings(DrawingDelta delta) {
    final List<Drawing> drawings = drawingsNotifier.value;

    switch (delta.operation) {
      case DrawingOperation.start:
        drawings.add(
          Drawing(
            deltas: [delta],
            metadata: delta.metadata,
          ),
        );
        break;
      case DrawingOperation.end:
        if (drawings.isEmpty) return;
        drawings.last.deltas.add(delta);
        break;
      case DrawingOperation.neutral:
        if (drawings.isEmpty) return;
        drawings.last.deltas.add(delta);
        break;
    }
    drawingsNotifier.value = List.from(drawings);
  }

  void panStart(details) {
    final DrawingDelta delta = DrawingDelta(
      metadata: const DrawingDeltaMetadata(
        color: Colors.black,
      ),
      point: PointDouble(
        details.localPosition.dx,
        details.localPosition.dy,
      ),
      operation: DrawingOperation.start,
    );

    addDeltaToDrawings(delta);
  }

  void panEnd(DragEndDetails details) {
    final DrawingDelta delta = DrawingDelta(
      point: drawingsNotifier.value.isEmpty
          ? const PointDouble(0, 0)
          : drawingsNotifier.value.last.deltas.last.point,
      operation: DrawingOperation.end,
    );

    addDeltaToDrawings(delta);
  }

  void panUpdate(DragUpdateDetails details) {
    final DrawingDelta delta = DrawingDelta(
      point: pointDoubleFromOffset(details.localPosition),
      metadata: DrawingDeltaMetadata(
        color: Colors.brown.withOpacity(0.5),
      ),
      operation: DrawingOperation.neutral,
    );

    addDeltaToDrawings(delta);
  }

  late final Drawing initialDrawing = Drawing(
    deltas: initialDelta,
  );

  final List<DrawingDelta> initialDelta = [
    const DrawingDelta(
      point: PointDouble(0, 0),
      operation: DrawingOperation.start,
    ),
    ...List<DrawingDelta>.generate(
      80,
      (index) => DrawingDelta(
        point: PointDouble(
          3 * (index + 2),
          4 * (index + 2),
        ),
      ),
    ),
    const DrawingDelta(
      point: PointDouble(7, 29),
      operation: DrawingOperation.end,
    ),
  ];

  @override
  void initState() {
    super.initState();
    drawingsNotifier.value = [initialDrawing];
    drawingsNotifier.addListener(() {
      if (drawingsNotifier.value.isEmpty) {
        erasingNotifier.value = false;
      }
      print('erasing value: ${erasingNotifier.value}');
    });
  }

// List<Drawing> splitDrawingDeltaToDrawings(Drawing drawing) {
//   drawing = List.from(drawing);
//   final List<Drawing> drawings = [];
//
//   bool currentlyAddingDrawing = false;
//   for (final DrawingDelta delta in drawing) {
//     if (delta.operation == DrawingOperation.start) {
//       currentlyAddingDrawing = true;
//       drawings.add([delta]);
//       continue;
//     }
//     if (currentlyAddingDrawing) {
//       drawings.last.add(delta);
//     }
//     if (delta.operation == DrawingOperation.end) {
//       currentlyAddingDrawing = false;
//     }
//   }
//   return drawings;
// }
}

// typedef Drawing = List<DrawingDelta>;

class Drawing {
  final List<DrawingDelta> deltas;
  final DrawingDeltaMetadata? metadata;

  const Drawing({
    required this.deltas,
    this.metadata,
  });
}

class Region {
  final PointDouble centre;
  final double radius;

  const Region({
    required this.centre,
    required this.radius,
  });

  double get minX => centre.x - radius;

  double get maxX => centre.x + radius;

  double get minY => centre.y - radius;

  double get maxY => centre.y + radius;

  bool containsPoint(PointDouble point) {
    final double x = point.x;
    final double y = point.y;

    final bool isPointInHorizontalRegion = x >= minX && x <= maxX;
    final bool isPointInVerticalRegion = y >= minY && y <= maxY;

    return isPointInHorizontalRegion && isPointInVerticalRegion;
  }
}
