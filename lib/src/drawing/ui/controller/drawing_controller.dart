import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawio/src/drawing/drawing_barrel.dart';
import 'package:flutter_drawio/src/utils/utils_barrel.dart';

/// This is the brain class of the package and is responsible for managing the state of the drawing process.
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
  Drawing? _currentlyActiveDrawing;

  Drawings get drawings => List.from(_drawings);

  @protected
  Drawings get mutableDrawing => _drawings;

  Drawing? get currentlyActiveDrawing => _currentlyActiveDrawing;

  set currentlyActiveDrawing(Drawing? value) {
    _currentlyActiveDrawing = value;
    notifyListeners();
  }

  final List<DrawingMode> _actionStack = List.from([]);

  void startDrawing() {
    currentlyActiveDrawing = switch (drawingMode) {
      DrawingMode.shape => ShapeDrawing(
          metadata: metadataFor(),
          shape: shape,
          deltas: [],
        ),
      DrawingMode.line => LineDrawing(
          deltas: [],
          metadata: metadataFor(),
        ),
      _ => SketchDrawing(
          metadata: metadataFor(),
          deltas: [],
        ),
    };
  }

  late DrawingMetadata lineMetadata;
  late DrawingMetadata shapeMetadata;
  late DrawingMetadata sketchMetadata;
  late Shape shape;

  /// this method is for to get metadata according to the current or last valid
  /// drawing mode
  DrawingMetadata metadataFor([DrawingMode? mode]) {
    switch (_actionStack.lastOrNull) {
      case DrawingMode.erase:
        {
          final DrawingMode? lastNonEraseMode = _actionStack.lastWhereOrNull(
            (element) => element != DrawingMode.erase,
          );
          if (lastNonEraseMode == null) return sketchMetadata;
          return metadataFor(lastNonEraseMode);
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

  /// This method is used to initialize the controller with the required parameters.
  ///
  /// It can/must be called only once.
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

  void changeStrokeWidth(double strokeWidth) {
    sketchMetadata = sketchMetadata.copyWith(strokeWidth: strokeWidth);
    shapeMetadata = shapeMetadata.copyWith(strokeWidth: strokeWidth);
    lineMetadata = lineMetadata.copyWith(strokeWidth: strokeWidth);

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
    if (delta.operation == DrawingOperation.start) {
      startDrawing();
    }
    Drawing? drawing = currentlyActiveDrawing;

    switch (drawingMode) {
      case DrawingMode.erase:
        eraser = eraser.copyWith(
          region: eraser.region.copyWith(centre: delta.point),
        );
        drawings = _erase(eraser, drawings);
        break;
      case DrawingMode.sketch:
        drawing = _sketch(delta, drawing!);
        break;
      case DrawingMode.shape:
        drawing = _drawShape(delta, drawing!);
        break;
      case DrawingMode.line:
        drawing = _drawLine(delta, drawing!);
        break;
    }
    //adds drawing if it's the last operation in the drawing, else updates the current drawing
    if (delta.operation == DrawingOperation.end) {
      drawings.add(drawing!);
      currentlyActiveDrawing = null;
      changeDrawings(drawings);
    } else {
      currentlyActiveDrawing = drawing;
    }
  }

  void clearDrawings() {
    if (_actionStack.lastOrNull == DrawingMode.erase) _actionStack.removeLast();
    changeDrawingMode(_actionStack.lastOrNull ?? DrawingMode.sketch);

    changeDrawings([]);

    notifyListeners();
  }

  Drawing _sketch(DrawingDelta delta, Drawing drawing) {
    drawing = drawing.copyWith(
      deltas: List.from(drawing.deltas)..add(delta),
    );
    return drawing;
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

  Drawing _drawLine(DrawingDelta delta, Drawing drawing) {
    drawing = drawing.copyWith(
      deltas: List.from(drawing.deltas)..add(delta),
    );
    return drawing;
  }

  Drawing _drawShape(DrawingDelta delta, Drawing drawing) {
    final Drawing drawnDrawings = drawing.copyWith(
      deltas: List.from(drawing.deltas)..add(delta),
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
          Drawing.convertDeltasToDrawing<T>(
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
