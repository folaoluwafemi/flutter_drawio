import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawer/src/drawing/drawing_barrel.dart';
import 'package:flutter_drawer/src/utils/utils_barrel.dart';

class DrawingController extends ChangeNotifier with EquatableMixin {
  DrawingController();

  late Eraser eraser;
  late DrawingMode _drawingMode;

  DrawingMode get drawingMode => _drawingMode;

  @protected
  set drawingMode(DrawingMode value) {
    _drawingMode = value;
  }

  Drawings _drawings = [];

  Drawings get drawings => List.from(_drawings);

  final List<DrawingMode> _actionStack = List.from([]);

  late DrawingMetadata lineMetadata;
  late DrawingMetadata shapeMetadata;
  late DrawingMetadata sketchMetadata;
  late Shape shape;

  DrawingMetadata metadataFor([DrawingMode? mode]) {
    switch (_actionStack.lastOrNull) {
      case DrawingMode.erase:
        {
          final DrawingMode? lastNonEraseMode = _actionStack.lastWhereOrNull(
            (element) => element != DrawingMode.erase,
          );
          if (lastNonEraseMode == null) return sketchMetadata;
          return metadataFor(
            lastNonEraseMode,
          );
        }
      case DrawingMode.sketch:
        return sketchMetadata;
      case DrawingMode.shape:
        return shapeMetadata;
      case DrawingMode.line:
        return lineMetadata;
      case null:
        return metadataFor(DrawingMode.erase);
    }
  }

  bool _initialized = false;

  bool get initialized => _initialized;

  void initialize({
    Color? color,
    Eraser? eraser,
    DrawingMode? drawingMode,
    DrawingMetadata? lineMetadata,
    DrawingMetadata? shapeMetadata,
    DrawingMetadata? sketchMetadata,
    Shape? shape,
    Drawings? drawings,
  }) {
    if (_initialized) return;
    _drawings = drawings ?? _drawings;

    this.shape = shape ?? Shape.rectangle;

    this.lineMetadata = lineMetadata ??
        DrawingMetadata(
          color: color ?? Colors.black,
          strokeWidth: 4,
        );
    this.shapeMetadata = shapeMetadata ??
        DrawingMetadata(
          color: color ?? Colors.black,
          strokeWidth: 4,
        );
    this.sketchMetadata = sketchMetadata ??
        DrawingMetadata(
          color: color ?? Colors.black,
          strokeWidth: 4,
        );

    this.drawingMode = drawingMode ?? DrawingMode.sketch;

    _actionStack.add(this.drawingMode);

    this.eraser = eraser ??
        const Eraser(
          region: Region(
            centre: PointDouble(0, 0),
            radius: 5,
          ),
          mode: EraseMode.drawing,
        );
    _initialized = true;
  }

  void changeDrawingMode(
    DrawingMode mode, [
    bool revertToPreviousAction = false,
  ]) {
    if (_actionStack.contains(mode)) _actionStack.remove(mode);
    _actionStack.add(mode);

    drawingMode = _actionStack.lastOrNull ?? mode;
    notifyListeners();
  }

  void changeShape(Shape newShape) {
    if (shape == newShape) return;
    shape = newShape;
    notifyListeners();
  }

  void toggleErase() {
    if (drawingMode == DrawingMode.erase) {
      changeDrawingMode(DrawingMode.sketch, true);
    } else {
      changeDrawingMode(DrawingMode.erase);
    }
  }

  void changeColor(Color color) {
    sketchMetadata = sketchMetadata.copyWith(color: color);
    shapeMetadata = shapeMetadata.copyWith(color: color);
    lineMetadata = lineMetadata.copyWith(color: color);

    notifyListeners();
  }

  void changeEraseMode(EraseMode mode) {
    if (eraser.mode == mode) return;
    eraser = eraser.copyWith(mode: mode);
    notifyListeners();
  }

  void changeDrawings(Drawings drawings) {
    if (drawings.isEmpty) {
      changeDrawingMode(_actionStack.lastOrNull ?? DrawingMode.sketch);
    }
    _drawings = List.from(drawings);
    notifyListeners();
  }

  void draw(DrawingDelta delta) {
    Drawings drawings = List.from(_drawings);

    if (delta.operation == DrawingOperation.end) {}
    switch (drawingMode) {
      case DrawingMode.erase:
        eraser = eraser.copyWith(
          region: eraser.region.copyWith(centre: delta.point),
        );
        drawings = _erase(eraser, drawings);
        // notifyOfSignificantUpdate();
        break;
      case DrawingMode.sketch:
        drawings = _sketch(delta, drawings);
        break;
      case DrawingMode.shape:
        drawings = _drawShape(delta, drawings);
        break;
      case DrawingMode.line:
        drawings = _drawLine(delta, drawings);
        break;
    }
    changeDrawings(drawings);
  }

  void clearDrawings() {
    if (_actionStack.lastOrNull == DrawingMode.erase) _actionStack.removeLast();
    changeDrawingMode(_actionStack.lastOrNull ?? DrawingMode.sketch);

    changeDrawings([]);

    notifyListeners();
  }

  Drawings _sketch(DrawingDelta delta, Drawings drawings) {
    final Drawings sketchedDrawings = addDeltaToDrawings<SketchDrawing>(
      delta,
      drawings,
      newMetadata: metadataFor(DrawingMode.sketch),
    );
    return sketchedDrawings;
  }

  Drawings _erase(Eraser eraser, Drawings drawings) {
    Drawings erasedDrawings;
    switch (eraser.mode) {
      case EraseMode.drawing:
        erasedDrawings = eraser.eraseDrawingFrom(drawings);
        break;
      case EraseMode.area:
        erasedDrawings = eraser.eraseAreaFrom(drawings);
        break;
    }
    if (erasedDrawings.every((element) => element.deltas.isEmpty)) {
      erasedDrawings.clear();
    }

    return erasedDrawings;
  }

  Drawings _drawLine(DrawingDelta delta, Drawings drawings) {
    // TODO: implement _drawLine
    throw UnimplementedError();
  }

  Drawings _drawShape(DrawingDelta delta, Drawings drawings) {
    final Drawings drawnDrawings = addDeltaToDrawings<ShapeDrawing>(
      delta,
      drawings,
      newMetadata: metadataFor(DrawingMode.shape),
    );
    return drawnDrawings;
  }

  Drawings removeLastDrawingFrom(Drawings drawings) {
    drawings = List.from(drawings);
    drawings.removeLast();

    return drawings;
  }

  Drawings addDeltaToDrawings<T extends Drawing>(
    DrawingDelta delta,
    Drawings drawings, {
    DrawingMetadata? newMetadata,
  }) {
    drawings = List.from(drawings);

    delta = delta.copyWith(
      metadata: newMetadata,
    );

    switch (delta.operation) {
      case DrawingOperation.start:
        drawings.add(
          Drawing.drawingType<T>(
            deltas: [delta],
            metadata: delta.metadata,
            shape: shape,
          ),
        );
        break;
      case DrawingOperation.end:
        if (drawings.isEmpty) return drawings;
        drawings.last.deltas.add(delta);
        break;
      case DrawingOperation.neutral:
        if (drawings.isEmpty) return drawings;
        drawings.last.deltas.add(delta);
        break;
    }
    return drawings;
  }

  bool equalsOther(
    DrawingController controller,
  ) {
    return controller.lineMetadata == lineMetadata &&
        controller.shapeMetadata == shapeMetadata &&
        controller.drawingMode == drawingMode &&
        controller.eraser == eraser &&
        controller.shape == shape &&
        UtilFunctions.listEqual(controller._actionStack, _actionStack) &&
        UtilFunctions.listEqual(controller._drawings, _drawings) &&
        controller.sketchMetadata == sketchMetadata;
  }

  Color get color {
    return sketchMetadata.color ??
        shapeMetadata.color ??
        lineMetadata.color ??
        Colors.black;
  }

  DrawingController copy({
    Color? color,
    Shape? shape,
    DrawingMode? drawingMode,
    Eraser? eraser,
    DrawingMetadata? lineMetadata,
    DrawingMetadata? shapeMetadata,
    DrawingMetadata? sketchMetadata,
    List<DrawingMode>? actionStack,
    List<Drawing>? drawings,
  }) {
    final DrawingController drawingController = DrawingController();

    drawingController._actionStack.clear();
    drawingController._actionStack.addAll(actionStack ?? _actionStack);
    drawingController.changeDrawings([]);
    drawingController.changeDrawings(drawings ?? this.drawings);

    return drawingController
      ..initialize(
        color: color ?? this.sketchMetadata.color,
        shape: shape ?? this.shape,
        drawingMode: drawingMode ?? this.drawingMode,
        eraser: eraser ?? this.eraser,
        lineMetadata: lineMetadata ?? this.lineMetadata,
        shapeMetadata: shapeMetadata ?? this.shapeMetadata,
        sketchMetadata: sketchMetadata ?? this.sketchMetadata,
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'eraser': eraser.toMap(),
      'drawingMode': drawingMode.index,
      'drawings': drawings.map<Map<String, dynamic>>((Drawing drawing) {
        return drawing.toMap();
      }).toList(),
      'lineMetadata': lineMetadata.toMap(),
      'shapeMetadata': shapeMetadata.toMap(),
      'sketchMetadata': sketchMetadata.toMap(),
      'shape': shape.index,
    };
  }

  factory DrawingController.fromMap(Map<String, dynamic> map) {
    final Color? color = int.tryParse(map['color'].toString()) == null
        ? null
        : Color(int.parse(map['color'].toString()));

    final DrawingController controller = DrawingController()
      ..initialize(
        eraser: Eraser.fromMap((map['eraser'] as Map).cast()),
        drawingMode: DrawingMode.values[map['drawingMode'] as int],
        drawings: (map['drawings'] as List)
            .cast<Map>()
            .map((data) => Drawing.fromMap(data.cast()))
            .toList(),
        lineMetadata:
            DrawingMetadata.fromMap((map['lineMetadata'] as Map).cast()),
        shapeMetadata:
            DrawingMetadata.fromMap((map['shapeMetadata'] as Map).cast()),
        sketchMetadata:
            DrawingMetadata.fromMap((map['sketchMetadata'] as Map).cast()),
        shape: Shape.values[map['shape'] as int],
      );
    if (color != null) {
      controller.changeColor(color);
    }
    return controller;
  }

  @override
  List<Object?> get props => [
        shapeMetadata,
        lineMetadata,
        sketchMetadata,
        _drawingMode,
        _initialized,
        ..._drawings,
      ];
}
